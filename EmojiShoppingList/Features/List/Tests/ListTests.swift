import ComposableArchitecture
import XCTest
import CoreData

@testable import Shopping_List

@MainActor
final class ListTests: XCTestCase {
    
    let mainQueue = DispatchQueue.test
    var mockFeedbackGenerator: MockFeedbackGenerator!
    var mockPersistence: MockPersistenceController!
    
    // MARK: SetUp / TearDown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockFeedbackGenerator = MockFeedbackGenerator()
        mockPersistence = MockPersistenceController()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockFeedbackGenerator = nil
        mockPersistence = nil
    }
    
    // MARK: List Feature - Appear
    
    func test_listFeature_appear_withNoItems() async {
        let items = ListItem.mockList
        let sortedItems = ListItem.mockSortedList
        mockPersistence.stubbedItemsResult = items
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.onAppear)
        await store.receive(.fetchItems)
        await store.receive(.fetchedItems(.success(items))) {
            $0.items = items
            XCTAssertEqual(
                self.mockPersistence.invokedItemsCount, 1,
                "Expected Persistence method 'Items' not invoked."
            )
        }
        await store.receive(.sortItems) {
            $0.items = sortedItems
        }
    }
    
    func test_listFeature_appear_withItems() async {
        let items = ListItem.mockList
        let sortedItems = ListItem.mockSortedList
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.onAppear)
        await store.receive(.sortItems) {
            $0.items = sortedItems
        }
    }
    
    // MARK: List Feature - Add Item
    
    func test_listFeature_addItem() async {
        let items = ListItem.mockList
        let mockItem = ListItem.mock
        mockPersistence.stubbedAddResult = mockItem
        
        var sortedItems = ListItem.mockSortedList
        sortedItems.insert(mockItem, at: 0)
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.inputAction(.submit(title: "Carrot")))
        await store.receive(.addItem(.success(mockItem)))
        await store.receive(.sortItems) {
            $0.items = sortedItems
            XCTAssertEqual(
                self.mockPersistence.invokedAddCount, 1,
                "Expected method 'Add' not invoked."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedAddParameters?.title, "Carrot",
                "Expected parameter 'title' to be 'Carrot'."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount, 1,
                "Expected method 'Impact' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft,
                "Expected parameter 'feedbackStyle' to be 'soft'."
            )
        }
    }
    
    // MARK: List Feature - Delete Items
    
    func test_listFeature_deleteAllItems() async {
        let items = ListItem.mockList
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )

        _ = await store.send(.deleteAction(.deleteTapped(type: .all))) {
            $0.items.removeAll()
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyCount, 1,
                "Expected method 'Notify' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyParameters?.feedbackType, .error,
                "Expected parameter 'feedbackType' to be 'error'."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedDeleteAllCount, 1,
                "Expected method 'DeleteAll' not invoked."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedDeleteAllParameters?.isDone, false,
                "Expected parameter isDone to be 'false'."
            )
        }
        await store.receive(.sortItems)
    }
    
    func test_listFeature_deleteStrikedItems() async {
        let items = ListItem.mockList
        var sortedItems = ListItem.mockSortedList
        sortedItems.removeAll(where: { $0.isDone == true  })
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.deleteAction(.deleteTapped(type: .striked))) {
            $0.items.removeAll(where: { $0.isDone == true  })
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyCount, 1,
                "Expected method 'Notify' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyParameters?.feedbackType, .error,
                "Expected parameter 'feedbackType' to be 'error'."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedDeleteAllCount, 1,
                "Expected method 'DeleteAll' not invoked."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedDeleteAllParameters?.isDone, true,
                "Expected parameter isDone to be 'true'."
            )
        }
        await store.receive(.sortItems) {
            $0.items = sortedItems
        }
    }
    
    func test_listFeature_deleteItem() async {
        let items = ListItem.mockList
        let itemToDelete = items.first!
        var sortedItems = ListItem.mockSortedList
        sortedItems.remove(itemToDelete)
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.listItem(id: itemToDelete.id, action: .delete)) {
            $0.items.remove(itemToDelete)
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount, 1,
                "Expected method 'Impact' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .rigid,
                "Expected parameter 'feedbackStyle' to be 'rigid'."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedDeleteCount, 1,
                "Expected method 'Delete' not invoked."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedDeleteParameters?.objectID, itemToDelete.id,
                "Expected parameter objectID to be 'itemToDelete.id'."
            )
        }
    }
    
    // MARK: List Feature - Complete Items
    
    func test_listFeature_completeItems() async {
        let items = ListItem.mockList
        let itemToToggle = items.first!
        let sortedItems = ListItem.mockSortedListUnchecked
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.listItem(id: itemToToggle.id, action: .toggleDone)) {
            $0.items[id: itemToToggle.id]?.isDone = false
        }
        await mainQueue.advance(by: .seconds(1))
        await store.receive(.sortItems) {
            $0.items = sortedItems
            XCTAssertEqual(
                self.mockPersistence.invokedUpdateCount, 1,
                "Expected method 'Update' not invoked."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedUpdateParameters?.listItem.id, itemToToggle.id,
                "Expected parameter listItem to be 'itemToToggle'."
            )
        }
    }
}
