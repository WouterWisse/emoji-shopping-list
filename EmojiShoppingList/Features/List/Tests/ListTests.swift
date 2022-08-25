import ComposableArchitecture
import XCTest
import CoreData

@testable import Shopping_List

final class ListTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    var mockFeedbackGenerator: MockFeedbackGenerator!
    var mockPersistenceController: MockPersistenceController!
    
    // MARK: SetUp / TearDown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockFeedbackGenerator = MockFeedbackGenerator()
        mockPersistenceController = MockPersistenceController()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockFeedbackGenerator = nil
        mockPersistenceController = nil
    }
    
    // MARK: Tests
    
    func test_onAppear() {
        let item = ListItem(
            id: NSManagedObjectID(),
            title: "Broccoli",
            emoji: "🥦",
            color: .green,
            isDone: false,
            amount: 1,
            createdAt: Date()
        )
        mockPersistenceController.stubbedItemsResult = [item]
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.onAppear) {
            $0.items = [item]
            store.receive(.sortItems) {
                $0.items = [item]
            }
            XCTAssertEqual(self.mockPersistenceController.invokedItemsCount, 1)
        }
    }
    
    func test_sortItems() {
        let items: IdentifiedArrayOf<ListItem> = [
            ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                emoji: "",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Avocado",
                emoji: "",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date()
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Spinach",
                emoji: "",
                color: .green,
                isDone: true,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Lemon",
                emoji: "",
                color: .green,
                isDone: true,
                amount: 1,
                createdAt: Date()
            )
        ]
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.sortItems) {
            $0.items = [items[1], items[0], items[3], items[2]]
        }
    }
    
    // MARK: ListItem Action
    
    func test_listItemAction_delete() {
        let items: IdentifiedArrayOf<ListItem> = [
            ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                emoji: "",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Avocado",
                emoji: "",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date()
            )
        ]
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        let itemToDelete: ListItem = items[0]
        
        store.send(.listItem(id: itemToDelete.id, action: .delete)) {
            $0.items.remove(items[0])
            store.receive(.sortItems) {
                $0.items.remove(items[0])
            }
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount,
                1
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle,
                .rigid
            )
            XCTAssertEqual(
                self.mockPersistenceController.invokedDeleteCount,
                1
            )
            XCTAssertEqual(
                self.mockPersistenceController.invokedDeleteParameters?.objectID,
                itemToDelete.id
            )
        }
    }
    
    // MARK: Input Action
    
    func test_inputAction_submit() {
        let item = ListItem(
            id: NSManagedObjectID(),
            title: "Avocado",
            emoji: "",
            color: .green,
            isDone: false,
            amount: 1,
            createdAt: Date.distantPast
        )
        mockPersistenceController.stubbedAddResult = item
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.inputAction(.submit("Avocado"))) {
            $0.items.append(item)
            store.receive(.sortItems) {
                $0.items.append(item)
            }
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount,
                1
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle,
                .soft
            )
            XCTAssertEqual(
                self.mockPersistenceController.invokedAddCount,
                1
            )
            XCTAssertEqual(
                self.mockPersistenceController.invokedAddParameters?.title,
                "Avocado"
            )
        }
    }
    
    // MARK: Delete Action
    
    func test_deleteAction_deleteAllTapped() {
        let items: IdentifiedArrayOf<ListItem> = [
            ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                emoji: "",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Avocado",
                emoji: "",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date()
            )
        ]
        
        let store = TestStore(
            initialState: ListState(items: items, deleteState: DeleteState(isPresented: true)),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.deleteAction(.deleteAllTapped)) {
            $0.items = []
            $0.deleteState.isPresented = false
            store.receive(.sortItems) {
                $0.items = []
                $0.deleteState.isPresented = false
            }
            
            XCTAssertEqual(
                self.mockPersistenceController.invokedDeleteAllCount,
                1
            )
            XCTAssertEqual(
                self.mockPersistenceController.invokedDeleteAllParameters?.isDone,
                false
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyCount,
                1
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyParameters?.feedbackType,
                .error
            )
        }
    }
    
    func test_deleteAction_deleteStrikedTapped() {
        let items: IdentifiedArrayOf<ListItem> = [
            ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                emoji: "",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Avocado",
                emoji: "",
                color: .green,
                isDone: true,
                amount: 1,
                createdAt: Date()
            )
        ]
        
        let store = TestStore(
            initialState: ListState(items: items, deleteState: DeleteState(isPresented: true)),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.deleteAction(.deleteStrikedTapped)) {
            $0.items = [items[0]]
            $0.deleteState.isPresented = false
            store.receive(.sortItems) {
                $0.items = [items[0]]
                $0.deleteState.isPresented = false
            }
            
            XCTAssertEqual(
                self.mockPersistenceController.invokedDeleteAllCount,
                1
            )
            XCTAssertEqual(
                self.mockPersistenceController.invokedDeleteAllParameters?.isDone,
                true
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyCount,
                1
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyParameters?.feedbackType,
                .error
            )
        }
    }
}
