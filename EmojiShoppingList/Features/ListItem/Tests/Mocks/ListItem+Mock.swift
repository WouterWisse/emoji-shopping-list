import CoreData

extension ListItem {
    static let mock = ListItem(
        id: NSManagedObjectID(),
        title: "Avocado",
        emoji: "🥑",
        color: .green,
        isDone: false,
        amount: 1,
        createdAt: Date()
    )
}
