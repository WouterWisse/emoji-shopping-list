import CoreData
import ComposableArchitecture

struct PersistenceController {
    var items: () async throws -> IdentifiedArrayOf<ListItem>
    var update: (_ listItem: ListItem) async throws -> Void
    var add: (_ title: String) async throws -> Void
    var delete: (_ objectID: NSManagedObjectID) async throws -> Void
    var deleteAll: (_ isDone: Bool) async throws -> Void
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
        
        let emojiProvider: EmojiProvider = .default
        let viewContext = NSManagedObjectContext(.privateQueue)
        
        return .init(
            items: {
                let items = try await viewContext.perform {
                    let request = Item.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
                    request.resultType = .dictionaryResultType
                    return try request.execute()
                }
                
                var listItems: IdentifiedArrayOf<ListItem> = []
                items.forEach { listItems.append(ListItem(item: $0)) }
                return listItems
            },
            update: { listItem in
                try await viewContext.perform {
                    let item = try viewContext.existingObject(with: listItem.id) as! Item
                    item.done = listItem.isDone
                    item.amount = listItem.amount
                    try viewContext.save()
                }
            },
            add: { title in
                let emoji = try await emojiProvider.emoji(title)
                
                try await viewContext.perform {
                    let item = Item.init(context: viewContext)
                    item.title = title
                    item.emoji = emoji.emoji
                    item.color = emoji.color
                    
                    item.createdAt = Date()
                    item.done = false
                    
                    try viewContext.save()
                }
            },
            delete: { objectID in
                try await viewContext.perform {
                    let item = try viewContext.existingObject(with: objectID)
                    viewContext.delete(item)
                    try viewContext.save()
                }
            },
            deleteAll: { isDone in
                try await viewContext.perform {
                    let request = Item.fetchRequest()
                    if isDone {
                        request.predicate = NSPredicate(format: "done == YES")
                    }
                    request.resultType = .managedObjectResultType
                    let items = try request.execute()
                    items.forEach(viewContext.delete)
                    try viewContext.save()
                }
            }
        )
    }()
}

extension PersistenceController {
    static let preview = PersistenceController.default
}
