import ComposableArchitecture
import SwiftUI

@main
struct EmojiShoppingListApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView(
                    store: Store(
                        initialState: ListState(),
                        reducer: listReducer,
                        environment: ListEnvironment(persistence: .default)
                    )
                )
            }
            // TODO: Add navigation buttons and logic here.
        }
    }
}

struct AppState: Equatable {
    var listState = ListState()
}

enum AppAction {
    case listAction(ListAction)
}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .listAction(let listAction):
        return .none
    }
}
