import ComposableArchitecture
import CoreData
import SwiftUI

// MARK: - Logic

struct ListState: Equatable {
    var items: IdentifiedArrayOf<ListItem> = []
    var inputState = InputState()
    var deleteState = DeleteState()
    
    var shouldShowEmptyState: Bool {
        items.isEmpty
    }
    
    var shouldShowDelete: Bool {
        !shouldShowEmptyState
    }
}

enum ListAction: Equatable {
    case onAppear
    case fetchItems
    case fetchedItems(TaskResult<IdentifiedArrayOf<ListItem>>)
    case addItem(TaskResult<ListItem>)
    case sortItems
    case listItem(id: ListItem.ID, action: ListItemAction)
    case inputAction(InputAction)
    case deleteAction(DeleteAction)
}

struct ListEnvironment {}

let listReducer = Reducer<
    ListState,
    ListAction,
    SharedEnvironment<ListEnvironment>
>.combine(
    listItemReducer.forEach(
        state: \.items,
        action: /ListAction.listItem(id:action:),
        environment: { _ in .live(environment: ListItemEnvironment()) }
    ),
    inputReducer.pullback(
        state: \.inputState,
        action: /ListAction.inputAction,
        environment: { _ in .live(environment: InputEnvironment()) }
    ),
    deleteReducer.pullback(
        state: \.deleteState,
        action: /ListAction.deleteAction,
        environment: { _ in .live(environment: DeleteEnvironment()) }
    ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            return .task { [items = state.items] in
                return items.isEmpty ? .fetchItems : .sortItems
            }
            
        case .fetchItems:
            return .task {
                await .fetchedItems(TaskResult { try await environment.persistence().items() })
            }
            
        case .fetchedItems(.success(let items)):
            state.items = items
            return .task { .sortItems }
            
        case .fetchedItems(.failure(let failure)):
            print("🍎 Fetch item failed with error: \(failure)")
            return .none
            
        case .addItem(.success(let item)):
            state.items.insert(item, at: 0)
            return .task { .sortItems }.animation()
            
        case .addItem(.failure(let failure)):
            print("🍎 Add item failed with error: \(failure)")
            return .none
            
        case .listItem(let id, let action):
            guard let item = state.items[id: id] else { return .none }
            enum ListItemCompletionID {}
            
            switch action {
            case .expandStepper(let expand):
                return .task {
                    if expand == false {
                        try await environment.persistence().update(item)
                    }
                    return .sortItems
                }
                
            case .updateAmount:
                return .none
                
            case .toggleDone:
                return .task {
                    try await environment.persistence().update(item)
                    try await environment.mainQueue().sleep(for: .seconds(1))
                    return .sortItems
                }
                .animation()
                .cancellable(id: ListItemCompletionID.self, cancelInFlight: true)
                
            case .delete:
                environment.feedbackGenerator().impact(.rigid)
                state.items.remove(item)
                return .task {
                    try await environment.persistence().delete(item.id)
                    return .sortItems
                }
                .animation()
            }
            
        case .sortItems:
            state.items.sort(by: { lhs, rhs in
                guard lhs.isDone == rhs.isDone else {
                    return !lhs.isDone && rhs.isDone
                }
                return lhs.createdAt > rhs.createdAt
            })
            return .none
            
        case .inputAction(let inputAction):
            switch inputAction {
            case .binding, .prepareForNextItem, .dismissKeyboard:
                return .none
                
            case .submit(let title):
                environment.feedbackGenerator().impact(.soft)
                return .task {
                    await .addItem(TaskResult { try await environment.persistence().add(title) })
                }
                .animation()
            }
            
        case .deleteAction(let deleteAction):
            switch deleteAction {
            case .deleteTapped(let type):
                environment.feedbackGenerator().notify(.error)
                if type == .striked {
                    state.items.removeAll(where: { $0.isDone })
                } else {
                    state.items.removeAll()
                }
                return .task {
                    try await environment.persistence().deleteAll(type == .striked)
                    return .sortItems
                }
                .animation()
            }
        }
    }
)
.debug()

// MARK: - View

struct ListView: View {
    let store: Store<ListState, ListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack(alignment: .top) {
                GeometryReader { geometryReader in
                    List {
                        TitleView()
                        
                        InputView(
                            store: store.scope(
                                state: \.inputState,
                                action: ListAction.inputAction
                            )
                        )
                        
                        ForEachStore(
                            store.scope(
                                state: \.items,
                                action: ListAction.listItem(id:action:)
                            ),
                            content: ListItemView.init(store:)
                        )
                        
                        if viewStore.shouldShowEmptyState {
                            EmptyStateView()
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: max(200, geometryReader.size.height - (geometryReader.safeAreaInsets.top + geometryReader.safeAreaInsets.bottom + 90)),
                                    alignment: .center)
                        }
                        
                        if viewStore.shouldShowDelete {
                            DeleteView(
                                store: store.scope(
                                    state: \.deleteState,
                                    action: ListAction.deleteAction
                                )
                            )
                        }
                    }
                    .listStyle(.plain)
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                }
                EdgeFadeView()
            }
        }
    }
}

// MARK: - Preview

struct ListView_Previews: PreviewProvider {
    static let previewItems: IdentifiedArrayOf<ListItem> = .preview
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            NavigationView {
                ListView(
                    store: Store(
                        initialState: ListState(
                            items: previewItems
                        ),
                        reducer: listReducer,
                        environment: .preview(environment: ListEnvironment())
                    )
                )
                .preferredColorScheme(colorScheme)
            }
        }
    }
}
