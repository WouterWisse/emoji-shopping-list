import ComposableArchitecture
import XCTest
import CoreData

@testable import Shopping_List

final class ListTests: XCTestCase {
    
    let scheduler = DispatchQueue.test
    var mockSettingsPersistence: MockSettingsPerstence!
    var mockFeedbackGenerator: MockFeedbackGenerator!
    
    // MARK: SetUp / TearDown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSettingsPersistence = MockSettingsPerstence()
        mockFeedbackGenerator = MockFeedbackGenerator()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mockSettingsPersistence = nil
        mockFeedbackGenerator = nil
    }
    
    // MARK: Tests
    
    func test_incrementAmount() {
        let listItems: IdentifiedArrayOf<ListItem> = [
            ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                isDone: false,
                amount: 1,
                createdAt: Date()
            )
        ]
        
        let store = TestStore(
            initialState: ListState(),
            reducer: listReducer,
            environment: .mock(
                environment: ListEnvironment(persistence: { .mock }),
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
}
