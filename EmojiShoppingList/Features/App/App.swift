import ComposableArchitecture
import SwiftUI

// MARK: - Logic

struct AppState: Equatable {
    var listState = ListState()
}

enum AppAction: Equatable {
    case listAction(ListAction)
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, SharedEnvironment<AppEnvironment>>.combine(
    listReducer.pullback(
        state: \.listState,
        action: /AppAction.listAction,
        environment: { _ in .live(environment: ListEnvironment()) }
    ),
    Reducer { state, action, environment in
        switch action {
        case .listAction:
            return .none
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
        WindowGroup {
            WithViewStore(self.store) { viewStore in
                ListView(
                    store: self.store.scope(
                        state: \.listState,
                        action: AppAction.listAction
                    )
                )
            }
        }
    }
}
