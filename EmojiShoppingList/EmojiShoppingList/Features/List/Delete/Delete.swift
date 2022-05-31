import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct DeleteState: Equatable {}

enum DeleteAction {
    case deleteAllTapped
    case deleteStrikedTapped
    case cancelTapped
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
        
    case .cancelTapped:
        return .none
    }
}

// MARK: - View

struct DeleteView: View {
    let store: Store<DeleteState, DeleteAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 12) {
                Text("🗑")
                    .font(.title2)
                    .frame(width: 50, height: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                
                Button {
                    withAnimation {
                        viewStore.send(.deleteAllTapped)
                    }
                } label: {
                    Text("All")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .tint(.red)
                
                Button {
                    withAnimation {
                        viewStore.send(.deleteStrikedTapped)
                    }
                } label: {
                    Text("Striked")
                        .strikethrough(true, color: .red.opacity(0.5))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(.red)
                
                Button {
                    withAnimation {
                        viewStore.send(.cancelTapped)
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
    }
}

struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteView(
            store: Store(
                initialState: DeleteState(),
                reducer: deleteReducer,
                environment: .mock(environment: DeleteEnvironment())
            )
        )
    }
}
