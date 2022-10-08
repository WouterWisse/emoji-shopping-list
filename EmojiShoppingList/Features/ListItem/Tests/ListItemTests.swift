import ComposableArchitecture
import XCTest
import CoreData

@testable import Shopping_List

@MainActor
final class ListItemTests: XCTestCase {
    
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
    
    // MARK: ListItem - Stepper Behaviour
    
    func test_listItemFeature_stepper() async {
        let store = TestStore(
            initialState: ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                emoji: "",
                color: .green,
                isDone: false,
                amount: 1,
                createdAt: Date()
            ),
            reducer: listItemReducer,
            environment: .mock(
                environment: ListItemEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.stepperTapped)
        await store.receive(.expandStepper(expand: true)) {
            $0.isStepperExpanded = true
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount, 1,
                "Expected method 'Impact' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft,
                "Expected parameter 'feedbackStyle' to be 'soft'."
            )
        }
        await mainQueue.advance(by: .seconds(3))
        await store.receive(.expandStepper(expand: false)) {
            $0.isStepperExpanded = false
        }
    }
    
    // MARK: ListItem - Update Amount
    
    func test_listItemFeature_amount() async {
        var state = ListItem(
            id: NSManagedObjectID(),
            title: "Broccoli",
            emoji: "",
            color: .green,
            isDone: false,
            amount: 1,
            createdAt: Date()
        )
        state.isStepperExpanded = true
        
        let store = TestStore(
            initialState: state,
            reducer: listItemReducer,
            environment: .mock(
                environment: ListItemEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.updateAmount(type: .increment)) {
            $0.amount += 1
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount, 1,
                "Expected method 'Impact' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft,
                "Expected parameter 'feedbackStyle' to be 'soft'."
            )
        }
        await mainQueue.advance(by: .seconds(1))
        _ = await store.send(.updateAmount(type: .decrement)) {
            $0.amount -= 1
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount, 2,
                "Expected method 'Impact' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft,
                "Expected parameter 'feedbackStyle' to be 'soft'."
            )
        }
        await mainQueue.advance(by: .seconds(2))
        await store.receive(.expandStepper(expand: false)) {
            $0.isStepperExpanded = false
            XCTAssertEqual(
                self.mockPersistence.invokedUpdateCount, 1,
                "Expected method 'Update' not invoked."
            )
            XCTAssertEqual(
                self.mockPersistence.invokedUpdateParameters?.listItem.id, state.id,
                "Expected parameter listItem to be 'itemToToggle'."
            )
        }
    }
    
    // MARK: ListItem - Completion
    
    func test_listItemFeature_completion() async {
        let store = TestStore(
            initialState: ListItem(
                id: NSManagedObjectID(),
                title: "Broccoli",
                emoji: "",
                color: .green,
                isDone: true,
                amount: 1,
                createdAt: Date()
            ),
            reducer: listItemReducer,
            environment: .mock(
                environment: ListItemEnvironment(),
                mainQueue: mainQueue.eraseToAnyScheduler(),
                persistence: mockPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        _ = await store.send(.toggleDone) {
            $0.isDone = false
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactCount, 1,
                "Expected method 'Impact' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .rigid,
                "Expected parameter 'feedbackStyle' to be 'rigid'."
            )
        }
        _ = await store.send(.toggleDone) {
            $0.isDone = true
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyCount, 1,
                "Expected method 'Notify' not invoked."
            )
            XCTAssertEqual(
                self.mockFeedbackGenerator.invokedNotifyParameters?.feedbackType, .success,
                "Expected parameter 'feedbackType' to be 'success'."
            )
        }
    }
}
