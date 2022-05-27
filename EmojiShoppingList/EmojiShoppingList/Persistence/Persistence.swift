import CoreData


struct PersistenceController {
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
