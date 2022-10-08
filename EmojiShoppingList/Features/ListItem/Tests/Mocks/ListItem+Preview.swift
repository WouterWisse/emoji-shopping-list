import ComposableArchitecture
import CoreData

extension IdentifiedArray where ID == ListItem.ID, Element == ListItem {
    static let preview: Self = [
        ListItem(
            id: NSManagedObjectID(),
            title: "Avocado",
            emoji: "🥑",
            color: .green,
            completed: false,
            amount: 1,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Eggplant",
            emoji: "🍆",
            color: .indigo,
            completed: true,
            amount: 2,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Apple",
            emoji: "🍎",
            color: .red,
            completed: false,
            amount: 99,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Beans",
            emoji: "🫘",
            color: .brown,
            completed: false,
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
        completed: false,
        amount: 1,
        createdAt: Date()
    )
}
