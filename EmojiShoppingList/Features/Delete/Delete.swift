import Foundation
import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct DeleteState: Equatable {}

enum DeleteAction: Equatable {
    enum DeleteActionType {
        case all, striked
    }
    case deleteTapped(type: DeleteActionType)
}

struct DeleteEnvironment {}

let deleteReducer = Reducer<
    DeleteState,
    DeleteAction,
    SharedEnvironment<DeleteEnvironment>
> { state, action, environment in
    switch action {
    case .deleteTapped(let type):
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
                        viewStore.send(.deleteTapped(type: .all), animation: .default)
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("All")
                                .font(.default)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        viewStore.send(.deleteTapped(type: .striked), animation: .default)
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
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 50)
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
