import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct InputState: Equatable {
    var title = ""
    var isFocused: Bool = false
}

enum InputAction: Equatable {
    case textFieldFocus
    case textFieldChanged(String)
    case submit
    case dismissKeyBoard
}

struct InputEnvironment {}

let inputReducer = Reducer<InputState, InputAction, InputEnvironment> { state, action, environment in
    switch action {
    case .textFieldFocus:
        state.isFocused = true
        return .none
        
    case .textFieldChanged(let string):
        return .none
        
    case .submit:
        state.isFocused = false
        return .none
         
    case .dismissKeyBoard:
        state.isFocused = false
        return .none
    }
}

// MARK: - View

struct InputView: View {
    let store: Store<InputState, InputAction>
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 12) {
                Text("✏️")
                    .font(.title2)
                    .frame(width: 50, height: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                
                TextField(
                    "",
                    text: viewStore.binding(
                        get: \.title,
                        send: InputAction.textFieldChanged
                    ),
                    prompt: Text("Add new item")
                )
                .font(.headline)
                .focused($isFocused)
                .onSubmit { viewStore.send(.submit) }
                .onChange(of: viewStore.isFocused) { focused in
                    isFocused = focused
                }
//                .onChange(of: isFocused) { focused in
//                    viewStore.send(.textFieldFocus)
//                }
                
                Spacer()
                
                if viewStore.isFocused {
                    Button {
                        withAnimation {
                            viewStore.send(.submit)
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
    }
}

// MARK: - Preview

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(
            store: Store(
                initialState: InputState(),
                reducer: inputReducer,
                environment: InputEnvironment()
            )
        )
    }
}
