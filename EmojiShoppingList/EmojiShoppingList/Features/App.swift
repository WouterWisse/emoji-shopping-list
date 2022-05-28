import ComposableArchitecture
import SwiftUI

@main
struct EmojiShoppingListApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(
                store: Store(
                    initialState: ListState(
                        inputState: .init()
                    ),
                    reducer: listReducer,
                    environment: ListEnvironment(persistence: PersistenceController.default)
                )
            )
        }
    }
}

struct AppState: Equatable {}

enum AppAction {}

struct AppEnvironment {}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
        // TODO: Add
    }
}
