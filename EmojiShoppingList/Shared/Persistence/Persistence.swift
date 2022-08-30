import CoreData
import UIKit

import ComposableArchitecture
import TextToEmoji

struct PersistenceController {
    var items: () -> IdentifiedArrayOf<ListItem>
    var update: (_ listItem: ListItem) -> Void
    var add: (_ title: String) -> ListItem?
    var delete: (_ objectID: NSManagedObjectID) -> Void
    var deleteAll: (_ isDone: Bool) -> Void
}

extension PersistenceController {
    static let `default`: PersistenceController = {
        let container = NSPersistentCloudKitContainer(name: "EmojiShoppingList")
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        let textToEmoji = TextToEmoji()
        let viewContext = container.viewContext
        
        let save: () -> Void = {
            do {
                try viewContext.save()
                print("🍏 Context successfully saved")
            } catch {
                print("🍎 Saving context failed with error: \(error)")
            }
        }
        
        return .init(
            items: {
                let request = NSFetchRequest<Item>(entityName: "Item")
                let sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
                request.sortDescriptors = sortDescriptors
                
                do {
                    let items = try viewContext.fetch(request) as [Item]
                    print("🍏 Items successfully fetched")
                    var listItems: IdentifiedArrayOf<ListItem> = []
                    items.forEach { listItems.append(ListItem(item: $0)) }
                    return listItems
                } catch {
                    print("🍎 Failed to fetch items")
                    return []
                }
            },
            update: { listItem in
                guard var item = viewContext.object(with: listItem.id) as? Item else {
                    return print("🍎 Item for \(listItem.id) to update not found")
                }
                item.done = listItem.isDone
                item.amount = listItem.amount
                save()
            },
            add: { title in
                print("🍏 Add item with title: \(title)")
                guard let newItem = NSEntityDescription.insertNewObject(
                    forEntityName: "Item",
                    into: viewContext
                ) as? Item else {
                    print("🍎 Creating new item failed")
                    return nil
                }
                
                let emoji = textToEmoji.emoji(for: title, preferredCategory: .foodAndDrink)
                
                newItem.title = title
                newItem.emoji = emoji
                let color = emoji?
                    .toImage()?
                    .averageColor?
                    .adjust(brightness: 0.55)
                newItem.color = color
                
                newItem.createdAt = Date()
                newItem.done = false
                save()
                
                return ListItem(item: newItem)
            },
            delete: { objectID in
                guard let item = viewContext.object(with: objectID) as? Item else {
                    return print("🍎 Item for \(objectID) to delete not found")
                }
                viewContext.delete(item)
                save()
            },
            deleteAll: { isDone in
                let request = NSFetchRequest<Item>(entityName: "Item")
                if isDone {
                    request.predicate = NSPredicate(format: "done == YES")
                }
                
                do {
                    let items = try viewContext.fetch(request) as [Item]
                    items.forEach(viewContext.delete)
                    save()
                    print("🍏 \(items.count) items successfully deleted")
                } catch {
                    print("🍎 Failed to delete items")
                }
            }
        )
    }()
}

extension PersistenceController {
    static let preview = PersistenceController.default
}
