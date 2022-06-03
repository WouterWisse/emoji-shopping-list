import ComposableArchitecture
import CoreData
import SwiftUI

// MARK: - Logic

struct ListState: Equatable {
    var items: IdentifiedArrayOf<ListItem> = []
    var inputState = InputState()
    var deleteState = DeleteState()
    var listName: String = "Shopping List"
}

enum ListAction {
    case onAppear
    case fetched(items: IdentifiedArrayOf<ListItem>)
    case deleteButtonTapped
    case sortItems
    case listItem(id: ListItem.ID, action: ListItemAction)
    case inputAction(InputAction)
    case deleteAction(DeleteAction)
}

struct ListEnvironment {
    var persistence: () -> PersistenceController
}

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
            if state.items.isEmpty {
                let items = environment.persistence().items()
                var listItems: IdentifiedArrayOf<ListItem> = []
                items.forEach { listItems.append(ListItem(item: $0)) }
                return Effect(value: .fetched(items: listItems))
            } else {
                return Effect(value: .fetched(items: state.items))
            }
            
        case .fetched(let items):
            state.items = items
            return Effect(value: .sortItems)
            
        case .listItem(let id, let action):
            guard let item = state.items[id: id] else { return .none }
            struct DebounceId: Hashable {}
            
            switch action {
            case .incrementAmount, .decrementAmount:
                environment.persistence().update(item)
                return .none
                
            case .toggleDone:
                environment.persistence().update(item)
                return Effect(value: .sortItems)
                    .debounce(
                        id: DebounceId(),
                        for: .seconds(1),
                        scheduler: environment.mainQueue()
                            .animation()
                            .eraseToAnyScheduler()
                    )
                
            case .delete:
                state.items.remove(item)
                environment.persistence().delete(item.id)
                return Effect(value: .sortItems)
            }
            
        case .deleteButtonTapped:
            state.deleteState.isPresented.toggle()
            return Effect(value: .sortItems)
            
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
            case .dismissKeyboard, .binding, .prepareForNextItem:
                return .none
                
            case .submit(let title):
                guard
                    title.isEmpty == false,
                    let newItem = environment.persistence().add(title)
                else { return .none }
                let newListItem = ListItem(item: newItem)
                state.items.append(newListItem)
                return Effect(value: .sortItems)
            }
            
        case .deleteAction(let deleteAction):
            switch deleteAction {
            case .deleteAllTapped:
                state.items.removeAll()
                environment.persistence().deleteAll(false)
                return Effect(value: .deleteButtonTapped)
                
            case .deleteStrikedTapped:
                state.items.removeAll(where: { $0.isDone })
                environment.persistence().deleteAll(true)
                return Effect(value: .deleteButtonTapped)
                
            case .cancelTapped:
                return Effect(value: .deleteButtonTapped)
            }
        }
    }
)
//.debug()

// MARK: - View

struct ListView: View {
    let store: Store<ListState, ListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ScrollViewReader { scrollProxy in
                GeometryReader { geometryProxy in
                    List {
                        if viewStore.deleteState.isPresented {
                            DeleteView(
                                store: self.store.scope(
                                    state: \.deleteState,
                                    action: ListAction.deleteAction
                                )
                            )
                            .id(DeleteViewID())
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
                            EmptyStateView(
                                height: geometryProxy.size.height - geometryProxy.safeAreaInsets.top
                            )
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle(viewStore.listName)
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
                    .onChange(of: viewStore.deleteState.isPresented, perform: { isPresented in
                        if isPresented {
                            withAnimation { scrollProxy.scrollTo(DeleteViewID(), anchor: .top) }
                        }
                    })
                }
            }
        }
    }
}

private struct DeleteViewID: Hashable {}

struct EmptyStateView: View {
    let height: CGFloat
    
    var body: some View {
        VStack {
            Text("👀")
                .font(.largeTitle)
            Text("Nothing on your list yet")
                .font(.headline)
                .opacity(0.25)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: height,
            maxHeight: .infinity,
            alignment: .center
        )
        .listRowSeparator(.hidden)
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
                        environment: .preview(
                            environment: ListEnvironment(
                                persistence: { .mock }
                            )
                        )
                    )
                )
                .preferredColorScheme(colorScheme)
            }
        }
    }
}
