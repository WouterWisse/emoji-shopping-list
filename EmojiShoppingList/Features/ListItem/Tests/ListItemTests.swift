import ComposableArchitecture
import XCTest
import CoreData

@testable import Shopping_List

final class ListItemTests: XCTestCase {
    
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
    
    func test_incrementAmount() {
        let store = TestStore(
            initialState: ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                isDone: false,
                amount: 1,
                createdAt: Date()
            ),
            reducer: listItemReducer,
            environment: .mock(
                environment: ListItemEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.incrementAmount) { state in
            state.amount = 2
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactCount, 1)
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft)
        }
    }
    
    func test_decrementAmount() {
        let store = TestStore(
            initialState: ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                isDone: false,
                amount: 2,
                createdAt: Date()
            ),
            reducer: listItemReducer,
            environment: .mock(
                environment: ListItemEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.decrementAmount) { state in
            state.amount = 1
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactCount, 1)
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft)
        }
    }
    
    func test_toggleDone() {
        let store = TestStore(
            initialState: ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                isDone: false,
                amount: 1,
                createdAt: Date()
            ),
            reducer: listItemReducer,
            environment: .mock(
                environment: ListItemEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.toggleDone) { state in
            state.isDone = true
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactCount, 1)
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .rigid)
        }
    }
}
