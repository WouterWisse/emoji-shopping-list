import ComposableArchitecture

struct ListState: Equatable {
    var items: [ListItem] = []
    var isSettingsPresented: Bool = false
    var isDeletePresented: Bool = false
}

enum ListAction: Equatable {
    case onAppear
    case fetched(items: [ListItem])
    case settingsButtonTapped
    case deleteButtonTapped
}

struct ListEnvironment {
    var persistence: PersistenceController
}

let listReducer = Reducer<
    ListState,
    ListAction,
    ListEnvironment
> { state, action, environment in
    switch action {
    case .onAppear:
        let items = environment.persistence.items()
        let listItems = items.map(ListItem.init)
        return Effect(value: .fetched(items: listItems))
        
    case .fetched(let items):
        state.items = items
        return .none
        
    case .settingsButtonTapped:
        state.isSettingsPresented.toggle()
        return .none
        
    case .deleteButtonTapped:
        state.isDeletePresented.toggle()
        return .none
    }
}
