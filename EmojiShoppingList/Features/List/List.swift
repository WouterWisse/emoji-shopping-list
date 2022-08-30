import ComposableArchitecture
import CoreData
import SwiftUI

// MARK: - Logic

struct ListState: Equatable {
    var items: IdentifiedArrayOf<ListItem> = []
    var navigationTitle: String = "Shopping List"
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
            
        case .listItem(let id, let action):
            guard let item = state.items[id: id] else { return .none }
            struct DebounceId: Hashable {}
            
            switch action {
            case .expandStepper(let expand):
                if expand == false {
                    environment.persistenceController().update(item)
                }
                return .none
                
            case .incrementAmount, .decrementAmount:
                return .none
                
            case .toggleDone:
                environment.persistenceController().update(item)
                return Effect(value: .sortItems)
                    .debounce(
                        id: DebounceId(),
                        for: .seconds(1.2),
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
            if let emoji = state.items.first?.emoji {
                state.navigationTitle = "\(emoji) Shopping List"
            } else {
                state.navigationTitle = "Shopping List"
            }
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
                    ScrollViewReader { scrollProxy in
                        List {
                            LinearGradient(
                                colors: Color.headerColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(
                                Text(viewStore.navigationTitle)
                                    .font(.header)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            )
                            .id(TitleViewID())
                            .frame(height: 40)
                            .padding(.top, 16)
                            .listRowSeparator(.hidden)
                            
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
                                EmptyStateView(height: geometryReader.size.height - 140)
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
                        .onChange(of: viewStore.deleteState.isPresented, perform: { isPresented in
                            if isPresented {
                                withAnimation { scrollProxy.scrollTo(TitleViewID(), anchor: .top) }
                            }
                        })
                    }
                    EdgeFadeView()
                }
            }
        }
    }
}

private struct TitleViewID: Hashable {}

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
