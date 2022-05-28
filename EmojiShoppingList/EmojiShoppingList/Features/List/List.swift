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
    case listItem(id: ListItem.ID, action: ListItemAction)
    case settingsButtonTapped
    case deleteButtonTapped
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
            
        case .settingsButtonTapped:
            state.isSettingsPresented.toggle()
            return .none
            
        case .deleteButtonTapped:
            state.isDeletePresented.toggle()
            return .none
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
                    if viewStore.isDeletePresented {
                        deleteView
                    } else {
                        inputView
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
    
    @State private var text: String = ""
    @FocusState private var isAddItemTextFieldFocussed: Bool
    
    var inputView: some View {
        HStack(spacing: 12) {
            Text("✏️")
                .font(.title2)
                .frame(width: 50, height: 50, alignment: .center)
                .multilineTextAlignment(.center)
            
            TextField("", text: $text, prompt: Text("Add new item"))
                .font(.headline)
                .focused($isAddItemTextFieldFocussed)
                .onSubmit(onSubmit)
            
            Spacer()
            
            if isAddItemTextFieldFocussed {
                Button {
                    withAnimation {
                        isAddItemTextFieldFocussed = false
                    }
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
                .tint(.accentColor)
            }
        }
        .listRowSeparatorTint(.clear)
    }
    
    var deleteView: some View {
        HStack(spacing: 12) {
            Text("🗑")
                .font(.title2)
                .frame(width: 50, height: 50, alignment: .center)
                .multilineTextAlignment(.center)
            
            Button {
                //
            } label: {
                Text("All (12)")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .tint(.red)
            
            Button {
                //
            } label: {
                Text("Striked (5)")
                    .strikethrough(true, color: .red.opacity(0.5))
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(.red)
            
            Button {
                withAnimation {
//                    isDeletePresented.toggle()
                }
            } label: {
                Text("Cancel")
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .tint(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowSeparatorTint(.clear)
    }
    
    private func onSubmit() {
        guard !text.isEmpty else {
            return isAddItemTextFieldFocussed = false
        }
        
//        addItem()
        text = ""
        isAddItemTextFieldFocussed = true
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
