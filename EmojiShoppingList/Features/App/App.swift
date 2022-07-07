import ComposableArchitecture
import SwiftUI

// MARK: - Logic

struct AppState: Equatable {
    var colorTheme: Color = .primary
    var listState = ListState()
    var settingsState = SettingsState()
}

enum AppAction: Equatable {
    case onAppear
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
        environment: { _ in .live(environment: ListEnvironment()) }
    ),
    settingsReducer.pullback(
        state: \.settingsState,
        action: /AppAction.settingsAction,
        environment: { _ in .live(environment: SettingsEnvironment()) }
    ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            let colorTheme = environment.colorThemeProvider().color()
            state.colorTheme = colorTheme
            state.listState.colorTheme = colorTheme
            state.settingsState.colorTheme = colorTheme
            return .none
            
        case .listAction(let listAction):
            return .none
            
        case .setSettings(let isPresented):
            state.settingsState.isPresented = isPresented
            return .none
            
        case .settingsButtonTapped:
            environment.feedbackGenerator().impact(.soft)
            state.settingsState.isPresented.toggle()
            return .none
            
        case .deleteButtonTapped:
            environment.feedbackGenerator().impact(.soft)
            state.listState.deleteState.isPresented.toggle()
            return .none
            
        case .settingsAction(let settingsAction):
            switch settingsAction {
            case .binding, .onAppear: return .none
            case .submit:
                return Effect(value: .listAction(.updateListName))
            }
        }
    }
)
.debug()

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
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                    .sheet(isPresented: viewStore.binding(
                        get: { $0.settingsState.isPresented },
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
                                Image(
                                    systemName: viewStore.listState.deleteState.isPresented
                                    ? "trash.slash"
                                    : "trash"
                                )
                            }
                        }
                    }
                    .tint(viewStore.colorTheme)
                }
            }
        }
    }
}
