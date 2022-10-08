import ComposableArchitecture
import XCTest
@testable import Shopping_List

@MainActor
final class InputTests: XCTestCase {
    
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
    
    // MARK: Input Features - Focus
    
    func test_dismissKeyboard() async {
        let store = TestStore(
            initialState: InputState(
                isInputFocused: false
            ),
            reducer: inputReducer,
            environment: .mock(
                environment: InputEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.focusDidChange(isFocused: true)) {
            $0.isInputFocused = true
        }
        _ = await store.send(.focusDidChange(isFocused: false)) {
            $0.isInputFocused = false
        }
    }
}
