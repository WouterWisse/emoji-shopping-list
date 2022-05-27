import CoreData

extension ListItem {
    static let mock = ListItem(
        id: NSManagedObjectID(),
        title: "Avocado",
        done: false,
        createdAt: Date()
    )
}
