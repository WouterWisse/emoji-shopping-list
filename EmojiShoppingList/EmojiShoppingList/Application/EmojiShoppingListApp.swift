import ComposableArchitecture
import SwiftUI

@main
struct EmojiShoppingListApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(
                store: Store(
                    initialState: ListState(),
                    reducer: listReducer,
                    environment: ListEnvironment(persistence: PersistenceController.default)
                )
            )
        }
    }
}
