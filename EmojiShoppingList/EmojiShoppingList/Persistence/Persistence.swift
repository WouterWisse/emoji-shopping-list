import CoreData


struct PersistenceController {
    var items: () -> [Item]
    var add: (_ title: String) -> Void
    var delete: (_ objectID: NSManagedObjectID) -> Void
    
    
    static let shared: PersistenceController = {
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
            add: { title in
                print("🍏 Add item with title: \(title)")
                guard let newItem = NSEntityDescription.insertNewObject(
                    forEntityName: "Item",
                    into: viewContext
                ) as? Item else { return print("🍎 Creating new item failed") }
                
                newItem.title = title
                newItem.createdAt = Date()
                newItem.done = false
                save()
            },
            delete: { objectID in
                guard let item = viewContext.object(with: objectID) as? Item else {
                    return print("🍎 Item for \(objectID) to delete not found")
                }
                viewContext.delete(item)
                save()
            }
        )
    }()
}
