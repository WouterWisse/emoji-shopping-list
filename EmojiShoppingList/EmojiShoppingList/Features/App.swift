import ComposableArchitecture
import SwiftUI

// MARK: - Logic

struct AppState: Equatable {
    var listState = ListState()
    var isSettingsPresented: Bool = false
}

enum AppAction {
    case listAction(ListAction)
    case setSettings(isPresented: Bool)
    case settingsButtonTapped
    case deleteButtonTapped
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    listReducer.pullback(
        state: \.listState,
        action: /AppAction.listAction,
        environment: { _ in ListEnvironment(persistence: .default, mainQueue: { .main }) }
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
        environment: AppEnvironment()
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
                        SettingsView()
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                withAnimation {
                                    viewStore.send(.settingsButtonTapped)
                                }
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                withAnimation {
                                    viewStore.send(.deleteButtonTapped)
                                }
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
