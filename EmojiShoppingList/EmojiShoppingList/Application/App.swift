import ComposableArchitecture

struct AppState: Equatable {
    var listState = ListState()
}

enum AppAction: Equatable {
    case listAction(ListAction)
}

struct AppEnvironment {
    
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    listReducer.pullback(
        state: \.listState,
        action: /AppAction.listAction,
        environment: { _ in ListEnvironment() }
    )
)
