import ComposableArchitecture
import CoreData
import SwiftUI

// MARK: - Logic

struct ListState: Equatable {
    var items: IdentifiedArrayOf<ListItem> = []
    var isSettingsPresented: Bool = false
    var isDeletePresented: Bool = false
}

enum ListAction: Equatable {
    case onAppear
    case fetched(items: IdentifiedArrayOf<ListItem>)
    case settingsButtonTapped
    case deleteButtonTapped
    case listItem(id: ListItem.ID, action: ListItemAction)
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
            
        case .settingsButtonTapped:
            state.isSettingsPresented.toggle()
            return .none
            
        case .deleteButtonTapped:
            state.isDeletePresented.toggle()
            return .none
            
        case .listItem(let id, let action):
            guard let item = state.items.first(where: { $0.id == id }) else { return .none }
            
            switch action {
            case .incrementAmount, .decrementAmount, .toggleDone:
                environment.persistence.update(item)
                return .none
                
            case .delete:
                state.items.remove(item)
                environment.persistence.delete(item.id)
                return .none
            }
        }
    }
)

// MARK: - View

struct ListView: View {
    let store: Store<ListState, ListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.items,
                            action: ListAction.listItem(id:action:)
                        ),
                        content: ListItemView.init(store:)
                    )
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
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
                initialState: ListState(items: .preview),
                reducer: listReducer,
                environment: ListEnvironment(
                    persistence: PersistenceController.mock
                )
            )
        )
    }
}
