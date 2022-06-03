import ComposableArchitecture
import XCTest
@testable import Shopping_List

final class InputTests: XCTestCase {
    
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
    
    func test_dismissKeyboard() {
        let store = TestStore(
            initialState: InputState(
                focusedField: .input
            ),
            reducer: inputReducer,
            environment: .mock(
                environment: InputEnvironment(),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.dismissKeyboard) { state in
            state.focusedField = nil
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount,
                1
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle,
                .soft
            )
        }
    }
    
    func test_prepareForNextItem() {
        let store = TestStore(
            initialState: InputState(
                inputText: "Broccoli",
                focusedField: .input,
                isFirstFieldFocus: true
            ),
            reducer: inputReducer,
            environment: .mock(
                environment: InputEnvironment(),
                mainQueue: self.scheduler.eraseToAnyScheduler(),
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.prepareForNextItem) {
            $0.isFirstFieldFocus = false
            $0.inputText = ""
        }
    }
}
