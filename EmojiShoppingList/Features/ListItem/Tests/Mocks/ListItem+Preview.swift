import ComposableArchitecture
import CoreData

extension IdentifiedArray where ID == ListItem.ID, Element == ListItem {
    static let preview: Self = [
        ListItem(
            id: NSManagedObjectID(),
            title: "Avocado",
            emoji: "🥑",
            isDone: false,
            amount: 1,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Eggplant",
            emoji: "🍆",
            isDone: true,
            amount: 2,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Apple",
            emoji: "🍎",
            isDone: false,
            amount: 99,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Beans",
            emoji: "🫘",
            isDone: false,
            amount: 1,
            createdAt: Date()
        ),
    ]
}
