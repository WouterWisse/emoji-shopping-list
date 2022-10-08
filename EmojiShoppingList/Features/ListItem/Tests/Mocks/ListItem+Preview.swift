import ComposableArchitecture
import CoreData

extension IdentifiedArray where ID == ListItem.ID, Element == ListItem {
    static let preview: Self = [
        ListItem(
            id: NSManagedObjectID(),
            title: "Avocado",
            emoji: "🥑",
            color: .green,
            isDone: false,
            amount: 1,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Eggplant",
            emoji: "🍆",
            color: .indigo,
            isDone: true,
            amount: 2,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Apple",
            emoji: "🍎",
            color: .red,
            isDone: false,
            amount: 99,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Beans",
            emoji: "🫘",
            color: .brown,
            isDone: false,
            amount: 1,
            createdAt: Date()
        ),
    ]
}

extension ListItem {
    static let preview = ListItem(
        id: NSManagedObjectID(),
        title: "Avocado",
        emoji: "🥑",
        color: .green,
        isDone: false,
        amount: 1,
        createdAt: Date()
    )
}
