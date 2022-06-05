import ComposableArchitecture
import XCTest
import CoreData

@testable import Shopping_List

final class ListTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    var mockSettingsPersistence: MockSettingsPerstence!
    var mockFeedbackGenerator: MockFeedbackGenerator!
    var mockPersistenceController: MockPersistenceController!
    
    // MARK: SetUp / TearDown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSettingsPersistence = MockSettingsPerstence()
        mockFeedbackGenerator = MockFeedbackGenerator()
        mockPersistenceController = MockPersistenceController()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockSettingsPersistence = nil
        mockFeedbackGenerator = nil
        mockPersistenceController = nil
    }
    
    // MARK: Tests
    
    func test_onAppear() {
        let listItems: IdentifiedArrayOf<ListItem> = [
            ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                isDone: false,
                amount: 1,
                createdAt: Date()
            )
        ]
        mockPersistenceController.stubbedItemsResult = listItems
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(persistence: { .mock(self.mockPersistenceController) }),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.onAppear) {
            $0.items = listItems
            store.receive(.sortItems)
        }
    }
    
    func test_deleteButtonTapped() {
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(persistence: { .mock(self.mockPersistenceController) }),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.deleteButtonTapped) {
            $0.deleteState.isPresented = true
            store.receive(.sortItems)
        }
    }
    
    func test_sortItems() {
        let items: IdentifiedArrayOf<ListItem> = [
            ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                isDone: false,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Avocado",
                isDone: false,
                amount: 1,
                createdAt: Date()
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Spinach",
                isDone: true,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Lemon",
                isDone: true,
                amount: 1,
                createdAt: Date()
            )
        ]
        
        let store = TestStore(
            initialState: ListState(items: items),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(persistence: { .mock(self.mockPersistenceController) }),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.sortItems) {
            $0.items = [items[1], items[0], items[3], items[2]]
        }
    }
    
    // MARK: ListItem Action
    
    func test_listItemAction_delete() {
        let id = NSManagedObjectID()
        let item = ListItem(
            id: id,
            title: "Broccoli",
            isDone: false,
            amount: 1,
            createdAt: Date()
        )
        
        let store = TestStore(
            initialState: ListState(items: [item]),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(persistence: { .mock(self.mockPersistenceController) }),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.listItem(id: id, action: .delete)) {
            $0.items.remove(item)
            store.receive(.sortItems)
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
                id
            )
        }
    }
    
    // MARK: Input Action
    
    func test_inputAction_submit() {
        let item = ListItem(
            id: NSManagedObjectID(),
            title: "Avocado",
            isDone: false,
            amount: 1,
            createdAt: Date.distantPast
        )
        mockPersistenceController.stubbedAddResult = item
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(persistence: { .mock(self.mockPersistenceController) }),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.inputAction(.submit("Avocado"))) {
            $0.items.append(item)
            store.receive(.sortItems)
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
                isDone: false,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Avocado",
                isDone: false,
                amount: 1,
                createdAt: Date()
            )
        ]
        
        let store = TestStore(
            initialState: ListState(items: items, deleteState: DeleteState(isPresented: true)),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(persistence: { .mock(self.mockPersistenceController) }),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.deleteAction(.deleteAllTapped)) {
            $0.items = []
            $0.deleteState.isPresented = false
            store.receive(.sortItems)
            
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
                isDone: false,
                amount: 1,
                createdAt: Date.distantPast
            ),
            ListItem(
                id: NSManagedObjectID(),
                title: "Avocado",
                isDone: true,
                amount: 1,
                createdAt: Date()
            )
        ]
        
        let store = TestStore(
            initialState: ListState(
                items: items,
                deleteState: DeleteState(isPresented: true)
            ),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(persistence: { .mock(self.mockPersistenceController) }),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.deleteAction(.deleteStrikedTapped)) {
            $0.items = [items[0]]
            $0.deleteState.isPresented = false
            store.receive(.sortItems)
            
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
