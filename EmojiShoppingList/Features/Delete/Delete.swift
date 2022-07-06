import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct DeleteState: Equatable {
    var isPresented: Bool = false
}

enum DeleteAction: Equatable {
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
.debug()

// MARK: - View

struct DeleteView: View {
    let store: Store<DeleteState, DeleteAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 12) {
                
                RoundEmojiView(emoji: "🗑", color: .clear, done: false)
                
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
