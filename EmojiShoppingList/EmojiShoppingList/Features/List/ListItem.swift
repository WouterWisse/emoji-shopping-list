import CoreData

struct ListItem: Equatable, Identifiable {
    let id: NSManagedObjectID
    let title: String
    let done: Bool
    let createdAt: Date
    
    init(item: Item) {
        self.id = item.objectID
        self.title = item.title!
        self.done = item.done
        self.createdAt = item.createdAt!
    }
    
    init(
        id: NSManagedObjectID,
        title: String,
        done: Bool,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.done = done
        self.createdAt = createdAt
    }
}

extension ListItem {
    static let mock = ListItem(
        id: NSManagedObjectID(),
        title: "Avocado",
        done: false,
        createdAt: Date()
    )
}
