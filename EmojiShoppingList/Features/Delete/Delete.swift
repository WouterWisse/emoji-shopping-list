import Foundation
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
            HStack {
                    Button {
                        viewStore.send(.deleteAllTapped, animation: .default)
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("All")
                                .font(.default)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        viewStore.send(.deleteStrikedTapped, animation: .default)
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Striked")
                                .strikethrough(true, color: .red.opacity(0.5))
                                .font(.default)
                        }
                    }
                    .buttonStyle(.bordered)
            }
            .tint(.red)
            .controlSize(.regular)
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
