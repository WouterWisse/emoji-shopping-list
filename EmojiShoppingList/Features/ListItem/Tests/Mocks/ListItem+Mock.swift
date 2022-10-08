import CoreData
import ComposableArchitecture
@testable import Shopping_List

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
        completed: false,
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
                completed: true,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 2000)
            ),
            ListItem(
                id: beerID,
                title: "Beer",
                emoji: "🍺",
                color: .brown,
                completed: false,
                amount: 6,
                createdAt: Date(timeIntervalSince1970: 0)
            ),
            ListItem(
                id: avocadoID,
                title: "Avocado",
                emoji: "🥑",
                color: .green,
                completed: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 500)
            ),
            ListItem(
                id: broccoliID,
                title: "Broccoli",
                emoji: "🥦",
                color: .green,
                completed: false,
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
                completed: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 1000)
            ),
            ListItem(
                id: avocadoID,
                title: "Avocado",
                emoji: "🥑",
                color: .green,
                completed: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 500)
            ),
            ListItem(
                id: beerID,
                title: "Beer",
                emoji: "🍺",
                color: .brown,
                completed: false,
                amount: 6,
                createdAt: Date(timeIntervalSince1970: 0)
            ),
            ListItem(
                id: pizzaID,
                title: "Pizza",
                emoji: "🍕",
                color: .red,
                completed: true,
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
                completed: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 2000)
            ),
            ListItem(
                id: broccoliID,
                title: "Broccoli",
                emoji: "🥦",
                color: .green,
                completed: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 1000)
            ),
            ListItem(
                id: avocadoID,
                title: "Avocado",
                emoji: "🥑",
                color: .green,
                completed: false,
                amount: 1,
                createdAt: Date(timeIntervalSince1970: 500)
            ),
            ListItem(
                id: beerID,
                title: "Beer",
                emoji: "🍺",
                color: .brown,
                completed: false,
                amount: 6,
                createdAt: Date(timeIntervalSince1970: 0)
            )
        ]
    }
}
