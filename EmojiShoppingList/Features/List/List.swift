import ComposableArchitecture
import CoreData
import SwiftUI

// MARK: - Logic

struct ListState: Equatable {
    var items: IdentifiedArrayOf<ListItem> = []
    var inputState = InputState()
    var deleteState = DeleteState()
    var listName: String = ""
    var colorTheme: ColorTheme = .primary
}

enum ListAction: Equatable {
    case onAppear
    case updateListName
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
            if state.items.isEmpty {
                state.items = environment.persistenceController().items()
                return Effect(value: .sortItems)
            } else {
                return Effect(value: .sortItems)
            }
            
        case .updateListName:
            let settings = environment.settingsPersistence()
            if let listName = settings.setting(.listName) as? String, !listName.isEmpty {
                state.listName = listName
            } else {
                let defaultListName = "Shopping List"
                settings.saveSetting(defaultListName, .listName)
                state.listName = defaultListName
            }
            return .none
            
        case .listItem(let id, let action):
            guard let item = state.items[id: id] else { return .none }
            struct DebounceId: Hashable {}
            
            switch action {
            case .incrementAmount, .decrementAmount:
                environment.persistenceController().update(item)
                return .none
                
            case .toggleDone:
                environment.persistenceController().update(item)
                return Effect(value: .sortItems)
                    .debounce(
                        id: DebounceId(),
                        for: .seconds(0.8),
                        scheduler: environment.mainQueue()
                            .animation()
                            .eraseToAnyScheduler()
                    )
                
            case .delete:
                state.items.remove(item)
                environment.persistenceController().delete(item.id)
                environment.feedbackGenerator().impact(.rigid)
                return Effect(value: .sortItems)
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
                guard
                    title.isEmpty == false,
                    let newItem = environment.persistenceController().add(title)
                else { return .none }
                state.items.append(newItem)
                return Effect(value: .sortItems)
            }
            
        case .deleteAction(let deleteAction):
            switch deleteAction {
            case .deleteAllTapped:
                state.items.removeAll()
                environment.persistenceController().deleteAll(false)
                environment.feedbackGenerator().notify(.error)
                state.deleteState.isPresented = false
                return Effect(value: .sortItems)
                
            case .deleteStrikedTapped:
                state.items.removeAll(where: { $0.isDone })
                environment.persistenceController().deleteAll(true)
                environment.feedbackGenerator().notify(.error)
                state.deleteState.isPresented = false
                return Effect(value: .sortItems)
                
            case .cancelTapped:
                environment.feedbackGenerator().impact(.soft)
                state.deleteState.isPresented = false
                return Effect(value: .sortItems)
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
            ScrollViewReader { scrollProxy in
                List {
                    if viewStore.deleteState.isPresented {
                        DeleteView(
                            store: self.store.scope(
                                state: \.deleteState,
                                action: ListAction.deleteAction
                            )
                        )
                        .listRowSeparator(.hidden)
                        .id(DeleteViewID())
                    } else {
                        InputView(
                            store: self.store.scope(
                                state: \.inputState,
                                action: ListAction.inputAction
                            )
                        )
                        .listRowSeparator(.hidden)
                    }
                    
                    ForEachStore(
                        self.store.scope(
                            state: \.items,
                            action: ListAction.listItem(id:action:)
                        ),
                        content: ListItemView.init(store:)
                    )
                    
                    if viewStore.items.isEmpty {
                        EmptyStateView()
                    }
                }
                .listStyle(.plain)
                .navigationTitle(viewStore.listName + "‎ ㅤ")
                .navigationBarColor(
                    backgroundColor: .systemBackground,
                    textColor: UIColor(viewStore.colorTheme.color)
                )
                .onAppear {
                    viewStore.send(.onAppear)
                    viewStore.send(.updateListName)
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

private struct DeleteViewID: Hashable {}

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
