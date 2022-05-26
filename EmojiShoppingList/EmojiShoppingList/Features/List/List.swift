import ComposableArchitecture

struct ListState: Equatable {
    
}

enum ListAction: Equatable {
    
}

struct ListEnvironment {}

let listReducer = Reducer<
    ListState,
    ListAction,
    ListEnvironment
> { state, action, environment in
    return .none
}
