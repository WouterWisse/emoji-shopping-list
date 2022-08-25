import ComposableArchitecture
import SwiftUI

// MARK: - Logic

struct AppState: Equatable {
    var listState = ListState()
}

enum AppAction: Equatable {
    case listAction(ListAction)
    case deleteButtonTapped
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
        case .listAction(let listAction):
            return .none
            
        case .deleteButtonTapped:
            environment.feedbackGenerator().impact(.soft)
            state.listState.deleteState.isPresented.toggle()
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
        WithViewStore(self.store) { viewStore in
            WindowGroup {
                NavigationView {
                    ListView(
                        store: self.store.scope(
                            state: \.listState,
                            action: AppAction.listAction
                        )
                    )
                    .toolbar {
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
                    .tint(.blue)
                }
            }
        }
    }
}
