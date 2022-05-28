import CoreData

extension ListItem {
    static let mock = ListItem(
        id: NSManagedObjectID(),
        title: "Avocado",
        isDone: false,
        amount: 1,
        createdAt: Date()
    )
}
