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
