import Foundation
import CoreData
import ComposableArchitecture

@testable import Shopping_List

extension PersistenceController {
    static let mock: (_ mock: MockPersistenceController?) -> PersistenceController = { mock in
        guard let mock = mock else {
            return PersistenceController(
                items: { fatalError("Mock not implemented") },
                update: { _ in fatalError("Mock not implemented") },
                add: { _ in fatalError("Mock not implemented") },
                delete: { _ in fatalError("Mock not implemented") },
                deleteAll: { _ in fatalError("Mock not implemented") }
            )
        }
        
        return PersistenceController(
            items: mock.items,
            update: mock.update,
            add: mock.add,
            delete: mock.delete,
            deleteAll: mock.deleteAll
        )
    }
}

final class MockPersistenceController {

    var invokedItems = false
    var invokedItemsCount = 0
    var stubbedItemsResult: IdentifiedArrayOf<ListItem>! = []

    func items() -> IdentifiedArrayOf<ListItem> {
        invokedItems = true
        invokedItemsCount += 1
        return stubbedItemsResult
    }

    var invokedUpdate = false
    var invokedUpdateCount = 0
    var invokedUpdateParameters: (listItem: ListItem, Void)?
    var invokedUpdateParametersList = [(listItem: ListItem, Void)]()
    var stubbedUpdateResult: Void! = ()

    func update(_ listItem: ListItem) -> Void {
        invokedUpdate = true
        invokedUpdateCount += 1
        invokedUpdateParameters = (listItem, ())
        invokedUpdateParametersList.append((listItem, ()))
        return stubbedUpdateResult
    }

    var invokedAdd = false
    var invokedAddCount = 0
    var invokedAddParameters: (title: String, Void)?
    var invokedAddParametersList = [(title: String, Void)]()
    var stubbedAddResult: Item!

    func add(_ title: String) -> Item? {
        invokedAdd = true
        invokedAddCount += 1
        invokedAddParameters = (title, ())
        invokedAddParametersList.append((title, ()))
        return stubbedAddResult
    }

    var invokedDelete = false
    var invokedDeleteCount = 0
    var invokedDeleteParameters: (objectID: NSManagedObjectID, Void)?
    var invokedDeleteParametersList = [(objectID: NSManagedObjectID, Void)]()
    var stubbedDeleteResult: Void! = ()

    func delete(_ objectID: NSManagedObjectID) -> Void {
        invokedDelete = true
        invokedDeleteCount += 1
        invokedDeleteParameters = (objectID, ())
        invokedDeleteParametersList.append((objectID, ()))
        return stubbedDeleteResult
    }

    var invokedDeleteAll = false
    var invokedDeleteAllCount = 0
    var invokedDeleteAllParameters: (isDone: Bool, Void)?
    var invokedDeleteAllParametersList = [(isDone: Bool, Void)]()
    var stubbedDeleteAllResult: Void! = ()

    func deleteAll(_ isDone: Bool) -> Void {
        invokedDeleteAll = true
        invokedDeleteAllCount += 1
        invokedDeleteAllParameters = (isDone, ())
        invokedDeleteAllParametersList.append((isDone, ()))
        return stubbedDeleteAllResult
    }
}
