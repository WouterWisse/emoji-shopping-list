import ComposableArchitecture
import CoreData
import SwiftUI

// MARK: - Logic

struct ListState: Equatable {
    var items: IdentifiedArrayOf<ListItem> = []
    var isSettingsPresented: Bool = false
    var isDeletePresented: Bool = false
    
    var inputState = InputState()
    var deleteState = DeleteState()
}

enum ListAction {
    case onAppear
    case fetched(items: IdentifiedArrayOf<ListItem>)
    case settingsButtonTapped
    case deleteButtonTapped
    
    case listItem(id: ListItem.ID, action: ListItemAction)
    case inputAction(InputAction)
    case deleteAction(DeleteAction)
}

struct ListEnvironment {
    var persistence: PersistenceController
}

let listReducer = Reducer<ListState, ListAction, ListEnvironment>.combine(
    listItemReducer.forEach(
        state: \.items,
        action: /ListAction.listItem(id:action:),
        environment: { _ in ListItemEnvironment() }
    ),
    inputReducer.pullback(
        state: \.inputState,
        action: /ListAction.inputAction,
        environment: { _ in InputEnvironment(mainQueue: { .main }) }
    ),
    deleteReducer.pullback(
        state: \.deleteState,
        action: /ListAction.deleteAction,
        environment: { _ in DeleteEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            let items = environment.persistence.items()
            var listItems: IdentifiedArrayOf<ListItem> = []
            items.forEach { item in
                listItems.append(ListItem(item: item))
            }
            return Effect(value: .fetched(items: listItems))
            
        case .fetched(let items):
            state.items = items
            return .none
            
        case .listItem(let id, let action):
            guard let item = state.items[id: id] else { return .none }
            
            switch action {
            case .incrementAmount, .decrementAmount, .toggleDone:
                environment.persistence.update(item)
                return .none
                
            case .delete:
                state.items.remove(item)
                environment.persistence.delete(item.id)
                return .none
            }
            
        case .settingsButtonTapped:
            state.isSettingsPresented.toggle()
            return .none
            
        case .deleteButtonTapped:
            state.isDeletePresented.toggle()
            return .none
            
        case .inputAction(let inputAction):
            switch inputAction {
            case .dismissKeyboard, .binding, .focusInputField:
                return .none
                
            case .submit(let title):
                guard
                    title.isEmpty == false,
                    let newItem = environment.persistence.add(title)
                else { return .none }
                let newListItem = ListItem(item: newItem)
                state.items.append(newListItem)
                return .none
            }
            
        case .deleteAction(let deleteAction):
            switch deleteAction {
            case .deleteAllTapped:
                state.items.removeAll()
                environment.persistence.deleteAll(false)
                return Effect(value: .deleteButtonTapped)
                
            case .deleteStrikedTapped:
                state.items.removeAll(where: { $0.isDone })
                environment.persistence.deleteAll(true)
                return Effect(value: .deleteButtonTapped)
                
            case .cancelTapped:
                return Effect(value: .deleteButtonTapped)
            }
        }
    }
)

// MARK: - View

struct ListView: View {
    let store: Store<ListState, ListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                if viewStore.isDeletePresented {
                    DeleteView(
                        store: self.store.scope(
                            state: \.deleteState,
                            action: ListAction.deleteAction
                        )
                    )
                } else {
                    InputView(
                        store: self.store.scope(
                            state: \.inputState,
                            action: ListAction.inputAction
                        )
                    )
                }
                
                ForEachStore(
                    self.store.scope(
                        state: \.items,
                        action: ListAction.listItem(id:action:)
                    ),
                    content: ListItemView.init(store:)
                )
                
                if viewStore.items.isEmpty {
                    VStack {
                        Text("👀")
                            .font(.largeTitle)
                        Text("Nothing on your list yet")
                            .font(.headline)
                            .opacity(0.25)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            viewStore.send(.settingsButtonTapped)
                        }
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            viewStore.send(.deleteButtonTapped)
                        }
                    } label: {
                        Image(systemName: viewStore.isDeletePresented ? "trash.slash" : "trash")
                    }
                }
            }
            //                .sheet(isPresented: $isSettingsPresented, content: {
            //                    SettingsView()
            //                })
            .navigationTitle("Shopping List")
        }
    }
}

// MARK: - Preview

extension IdentifiedArray where ID == ListItem.ID, Element == ListItem {
    static let preview: Self = [
        ListItem(
            id: NSManagedObjectID(),
            title: "Avocado",
            isDone: false,
            amount: 1,
            createdAt: Date()
        ),
    ]
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(
            store: Store(
                initialState: ListState(
                    items: .preview
                ),
                reducer: listReducer,
                environment: ListEnvironment(
                    persistence: .mock
                )
            )
        )
    }
}
