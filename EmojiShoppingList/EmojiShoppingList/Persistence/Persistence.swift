import CoreData

struct PersistenceController {
    var items: () -> [Item]
    var update: (_ listItem: ListItem) -> Void
    var add: (_ title: String) -> Item?
    var delete: (_ objectID: NSManagedObjectID) -> Void
    var deleteAll: (_ isDone: Bool) -> Void
    
    
    static let `default`: PersistenceController = {
        let container = NSPersistentCloudKitContainer(name: "EmojiShoppingList")
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
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
                    return items
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
                
                newItem.title = title
                newItem.createdAt = Date()
                newItem.done = false
                save()
                
                return newItem
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
    
    final class MockItem: Item {
        convenience init(title: String? = "", done: Bool = false) {
            self.init()
            self.stubbedTitle = title
            self.stubbedDone = done
            self.stubbedCreatedAt = Date()
        }
        
        var stubbedTitle: String? = ""
        override var title: String? {
            set { stubbedTitle = newValue }
            get { stubbedTitle }
        }
        
        var stubbedDone: Bool = false
        override var done: Bool {
            set { stubbedDone = newValue }
            get { stubbedDone }
        }
        
        var stubbedCreatedAt: Date? = Date()
        override var createdAt: Date? {
            set { stubbedCreatedAt = newValue }
            get { stubbedCreatedAt }
        }
    }
    
    static let mock: PersistenceController = {
        return .init(
            items: {
                [
                    MockItem(title: "Avocado"),
                    MockItem(title: "Banana"),
                    MockItem(title: "Broccoli", done: true),
                    MockItem(title: "Beer"),
                    MockItem(title: "Strawberries"),
                    MockItem(title: "Bell Pepper"),
                    MockItem(title: "Carrot"),
                ]
            },
            update: { _ in fatalError("Mock not implemented") },
            add: { _ in fatalError("Mock not implemented") },
            delete: { _ in fatalError("Mock not implemented") },
            deleteAll: { _ in fatalError("Mock not implemented") }
        )
    }()
}
