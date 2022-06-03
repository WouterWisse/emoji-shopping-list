import ComposableArchitecture
import XCTest
@testable import Shopping_List

final class InputTests: XCTestCase {
    let scheduler = DispatchQueue.test
    
    // MARK: Tests
    
    func test_submit_shouldInvokeFeedback() {
        let store = TestStore(
            initialState: InputState(),
            reducer: inputReducer,
            environment: .mock(environment: InputEnvironment())
        )
    }
}
