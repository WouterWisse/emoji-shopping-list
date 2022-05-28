import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct InputState: Equatable {
    @BindableState var inputText: String = ""
}

enum InputAction: BindableAction {
    case binding(BindingAction<InputState>)
    case submit(String)
    case dismissKeyboard
}

struct InputEnvironment {}

let inputReducer = Reducer<InputState, InputAction, InputEnvironment> { state, action, environment in
    switch action {
    case .submit:
        state.inputText = ""
        return .none
        
    case .dismissKeyboard:
        return .none
        
    case .binding(\.$inputText):
        return .none
        
    case .binding:
        return .none
    }
}.binding()

// MARK: - View

struct InputView: View {
    let store: Store<InputState, InputAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: 12) {
                Text("✏️")
                    .font(.title2)
                    .frame(width: 50, height: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                
                TextField(
                    "",
                    text: viewStore.binding(\.$inputText),
                    prompt: Text("Add new item")
                )
                .font(.headline)
                .onSubmit {
                    withAnimation {
                        viewStore.send(.submit(viewStore.inputText))
                    }
                }
                
                Spacer()
                
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
