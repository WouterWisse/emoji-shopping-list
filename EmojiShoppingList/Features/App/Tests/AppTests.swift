import ComposableArchitecture
import XCTest
import CoreData

@testable import Shopping_List

final class AppTests: XCTestCase {
    
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
    
    // MARK: App
    
    func test_setSettings_withTrue() {
        let store = TestStore(
            initialState: AppState(listState: ListState()),
            reducer: appReducer,
            environment: .mock(
                environment: AppEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.setSettings(isPresented: true)) {
            $0.settingsState.isPresented = true
        }
    }
    
    func test_setSettings_withFalse() {
        let store = TestStore(
            initialState: AppState(
                listState: ListState(),
                settingsState: SettingsState(isPresented: true)
            ),
            reducer: appReducer,
            environment: .mock(
                environment: AppEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.setSettings(isPresented: false)) {
            $0.settingsState.isPresented = false
        }
    }
    
    func test_settingsButtonTapped_withNotPresented_shouldToggle() {
        let store = TestStore(
            initialState: AppState(
                listState: ListState(),
                settingsState: SettingsState(isPresented: false)
            ),
            reducer: appReducer,
            environment: .mock(
                environment: AppEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.settingsButtonTapped) {
            $0.settingsState.isPresented = true
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactCount, 1)
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft)
        }
    }
    
    func test_settingsButtonTapped_withPresented_shouldToggle() {
        let store = TestStore(
            initialState: AppState(
                listState: ListState(),
                settingsState: SettingsState(isPresented: true)
            ),
            reducer: appReducer,
            environment: .mock(
                environment: AppEnvironment(),
                mainQueue: scheduler.eraseToAnyScheduler(),
                persistenceController: mockPersistenceController,
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.settingsButtonTapped) {
            $0.settingsState.isPresented = false
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactCount, 1)
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft)
        }
    }
    
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
                settingsPersistence: mockSettingsPersistence,
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
                settingsPersistence: mockSettingsPersistence,
                feedbackGenerator: mockFeedbackGenerator
            )
        )
        
        store.send(.deleteButtonTapped) {
            $0.listState.deleteState.isPresented = false
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactCount, 1)
            XCTAssertEqual(self.mockFeedbackGenerator.invokedImpactParameters?.feedbackStyle, .soft)
        }
    }
    
    // MARK: Settings Actions
    
//    func test_settingsAction_submit() {
//        mockSettingsPersistence.stubbedSettingResult = "New Title"
//        
//        let listItem = ListItem(
//            id: NSManagedObjectID(),
//            title: "Avocado",
//            isDone: false,
//            amount: 1,
//            createdAt: Date()
//        )
//        
//        let store = TestStore(
//            initialState: AppState(listState: ListState(items: [listItem])),
//            reducer: appReducer,
//            environment: .mock(
//                environment: AppEnvironment(),
//                mainQueue: self.scheduler.eraseToAnyScheduler(),
//                settingsPersistence: mockSettingsPersistence,
//                feedbackGenerator: mockFeedbackGenerator
//            )
//        )
//        
//        store.send(.settingsAction(.submit)) {
//            $0.listState.listName = "New Title"
//            store.receive(.listAction(.onAppear))
//            store.receive(.listAction(.sortItems))
//        }
//    }
}
