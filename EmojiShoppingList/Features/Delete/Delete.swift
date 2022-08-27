import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct DeleteState: Equatable {
    var isPresented: Bool = false
}

enum DeleteAction: Equatable {
    case deleteAllTapped
    case deleteStrikedTapped
}

struct DeleteEnvironment {}

let deleteReducer = Reducer<
    DeleteState,
    DeleteAction,
    SharedEnvironment<DeleteEnvironment>
> { state, action, environment in
    switch action {
    case .deleteAllTapped:
        return .none
        
    case .deleteStrikedTapped:
        return .none
    }
}
.debug()

// MARK: - View

struct DeleteView: View {
    let store: Store<DeleteState, DeleteAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 12) {
                    Button {
                        withAnimation {
                            viewStore.send(.deleteAllTapped)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("All")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        withAnimation {
                            viewStore.send(.deleteStrikedTapped)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Striked")
                                .strikethrough(true, color: .red.opacity(0.5))
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                    }
                    .buttonStyle(.bordered)
            }
            .tint(.red)
            .controlSize(.regular)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .listRowSeparator(.visible, edges: .top)
            .listRowSeparator(.hidden, edges: .bottom)
        }
    }
}

// MARK: Preview

struct DeleteView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            DeleteView(
                store: Store(
                    initialState: DeleteState(),
                    reducer: deleteReducer,
                    environment: .preview(environment: DeleteEnvironment())
                )
            )
            .preferredColorScheme(colorScheme)
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}
