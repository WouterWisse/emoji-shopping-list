import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "EmojiShoppingList")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

// MARK: Preview

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let titles = [
            "Avocado",
            "Banana",
            "Broccoli",
            "Strawberries",
            "Milk",
            "Cheese",
            "Eggs",
            "Wine",
        ]
        
        let emojis = [
            "🥑",
            "🍌",
            "🥦",
            "🍓",
            "🥛",
            "🧀",
            "🥚",
            "🍷"
        ]
        
        titles.enumerated().forEach { index, title in
            let newItem = Item(context: viewContext)
            newItem.title = title
            newItem.emoji = emojis[index]
            newItem.createdAt = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var previewItem: Item {
        let newItem = Item(context: preview.container.viewContext)
        newItem.title = "Avocado"
        newItem.emoji = "🥑"
        newItem.createdAt = Date()
        return newItem
    }
    
    static var previewDoneItem: Item {
        let newItem = Item(context: preview.container.viewContext)
        newItem.title = "Avocado"
        newItem.emoji = "🥑"
        newItem.createdAt = Date()
        newItem.done = true
        return newItem
    }
}
