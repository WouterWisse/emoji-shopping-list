import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct InputState: Equatable {
    var title = ""
    var isFocused: Bool = false
}

enum InputAction: Equatable {
    case textFieldFocus(Bool)
    case textFieldChanged(String)
    case submit(String)
    case dismissKeyboard
}

struct InputEnvironment {}

let inputReducer = Reducer<InputState, InputAction, InputEnvironment> { state, action, environment in
    switch action {
    case .textFieldFocus(let isFocused):
        state.isFocused = isFocused
        return .none
        
    case .textFieldChanged(let string):
        state.title = string
        return .none
        
    case .submit:
        state.title = ""
        state.isFocused = true
        return .none
         
    case .dismissKeyboard:
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
                .onSubmit {
                    withAnimation {
                        viewStore.send(.submit(viewStore.title))
                    }
                }
                .onChange(of: viewStore.isFocused) { focused in
                    isFocused = focused
                }
                
                Spacer()
                
                if viewStore.isFocused {
                    Button {
                        withAnimation {
                            viewStore.send(.dismissKeyboard)
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
