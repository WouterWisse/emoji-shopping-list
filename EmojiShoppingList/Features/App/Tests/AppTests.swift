import ComposableArchitecture
import XCTest
import CoreData

@testable import Shopping_List

final class AppTests: XCTestCase {
    
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

    // MARK: App
    
    func test_deleteButtonTapped_withNotPresented_shouldToggle() {
        let store = TestStore(
            initialState: AppState(
                listState: ListState(deleteState: DeleteState(isPresented: false))
            ),
            reducer: appReducer,
            environment: .mock(
                environment: AppEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.deleteButtonTapped) {
            $0.listState.deleteState.isPresented = true
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactCount, 1)
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft)
        }
    }
    
    func test_deleteButtonTapped_withPresented_shouldToggle() {
        let store = TestStore(
            initialState: AppState(
                listState: ListState(deleteState: DeleteState(isPresented: true))
            ),
            reducer: appReducer,
            environment: .mock(
                environment: AppEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.deleteButtonTapped) {
            $0.listState.deleteState.isPresented = false
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactCount, 1)
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft)
        }
    }
}
