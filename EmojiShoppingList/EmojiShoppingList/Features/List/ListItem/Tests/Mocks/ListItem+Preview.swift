import ComposableArchitecture
import CoreData

extension IdentifiedArray where ID == ListItem.ID, Element == ListItem {
    static let preview: Self = [
        ListItem(
            id: NSManagedObjectID(),
            title: "Avocado",
            isDone: false,
            amount: 1,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Eggplant",
            isDone: true,
            amount: 2,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Apple",
            isDone: false,
            amount: 1,
            createdAt: Date()
        ),
        ListItem(
            id: NSManagedObjectID(),
            title: "Beans",
            isDone: false,
            amount: 1,
            createdAt: Date()
        ),
    ]
}
