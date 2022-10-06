import CoreData
import ComposableArchitecture

extension ListItem {
    static var carrotID = NSManagedObjectID()
    static var pizzaID = NSManagedObjectID()
    static var beerID = NSManagedObjectID()
    static var avocadoID = NSManagedObjectID()
    static var broccoliID = NSManagedObjectID()
    
    static let mock = ListItem(
        id: avocadoID,
        title: "Carrot",
        emoji: "🥕",
        color: .orange,
        isDone: false,
        amount: 1,
        createdAt: Date(timeIntervalSince1970: 9999)
    )

    static var mockList: IdentifiedArrayOf<ListItem> {
        [
            ListItem(
                id: pizzaID,
                title: "Pizza",
                emoji: "🍕",
                color: .red,
                isDone: true,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 2000)
            ),
            ListItem(
                id: beerID,
                title: "Beer",
                emoji: "🍺",
                color: .brown,
                isDone: false,
                amount: 6,
                createdAt: Date(timeIntervalSince1970: 0)
            ),
            ListItem(
                id: avocadoID,
                title: "Avocado",
                emoji: "🥑",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 500)
            ),
            ListItem(
                id: broccoliID,
                title: "Broccoli",
                emoji: "🥦",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 1000)
            )
        ]
    }
    
    static var mockSortedList: IdentifiedArrayOf<ListItem> {
        [
            ListItem(
                id: broccoliID,
                title: "Broccoli",
                emoji: "🥦",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 1000)
            ),
            ListItem(
                id: avocadoID,
                title: "Avocado",
                emoji: "🥑",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 500)
            ),
            ListItem(
                id: beerID,
                title: "Beer",
                emoji: "🍺",
                color: .brown,
                isDone: false,
                amount: 6,
                createdAt: Date(timeIntervalSince1970: 0)
            ),
            ListItem(
                id: pizzaID,
                title: "Pizza",
                emoji: "🍕",
                color: .red,
                isDone: true,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 2000)
            )
        ]
    }
    
    static var mockSortedListUnchecked: IdentifiedArrayOf<ListItem> {
        [
            ListItem(
                id: pizzaID,
                title: "Pizza",
                emoji: "🍕",
                color: .red,
                isDone: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 2000)
            ),
            ListItem(
                id: broccoliID,
                title: "Broccoli",
                emoji: "🥦",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 1000)
            ),
            ListItem(
                id: avocadoID,
                title: "Avocado",
                emoji: "🥑",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 500)
            ),
            ListItem(
                id: beerID,
                title: "Beer",
                emoji: "🍺",
                color: .brown,
                isDone: false,
                amount: 6,
                createdAt: Date(timeIntervalSince1970: 0)
            )
        ]
    }
}
