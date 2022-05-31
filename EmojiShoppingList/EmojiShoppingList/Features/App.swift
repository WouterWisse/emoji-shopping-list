import ComposableArchitecture
import SwiftUI

// MARK: - Logic

struct AppState: Equatable {
    var listState = ListState()
    var settingsState = SettingsState()
    var isSettingsPresented: Bool = false
}

enum AppAction {
    case listAction(ListAction)
    case settingsAction(SettingsAction)
    case setSettings(isPresented: Bool)
    case settingsButtonTapped
    case deleteButtonTapped
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, SharedEnvironment<AppEnvironment>>.combine(
    listReducer.pullback(
        state: \.listState,
        action: /AppAction.listAction,
        environment: { _ in .live(environment: ListEnvironment(persistence: { .default })) }
    ),
    settingsReducer.pullback(
        state: \.settingsState,
        action: /AppAction.settingsAction,
        environment: { _ in .live(environment: SettingsEnvironment()) }
    ),
    Reducer { state, action, environment in
        switch action {
        case .listAction(let listAction):
            return .none
            
        case .setSettings(let isPresented):
            state.isSettingsPresented = isPresented
            return .none
            
        case .settingsButtonTapped:
            state.isSettingsPresented.toggle()
            return .none
            
        case .deleteButtonTapped:
            state.listState.isDeletePresented.toggle()
            return .none
        }
    }
)

// MARK: - View

@main
struct EmojiShoppingListApp: App {
    let store: Store<AppState, AppAction> = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: .live(environment: AppEnvironment())
    )
    
    var body: some Scene {
        WithViewStore(self.store) { viewStore in
            WindowGroup {
                NavigationView {
                    ListView(
                        store: self.store.scope(
                            state: \.listState,
                            action: AppAction.listAction
                        )
                    )
                    .sheet(isPresented: viewStore.binding(
                        get: { $0.isSettingsPresented },
                        send:  AppAction.setSettings(isPresented:))
                    ) {
                        SettingsView(
                            store: self.store.scope(
                                state: \.settingsState,
                                action: AppAction.settingsAction
                            )
                        )
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                withAnimation { viewStore.send(.settingsButtonTapped) }
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                withAnimation { viewStore.send(.deleteButtonTapped) }
                            } label: {
                                Image(systemName: viewStore.listState.isDeletePresented ? "trash.slash" : "trash")
                            }
                        }
                    }
                }
            }
        }
    }
}
