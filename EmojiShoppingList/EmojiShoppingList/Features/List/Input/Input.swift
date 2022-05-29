import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct InputState: Equatable {
    @BindableState var inputText: String = ""
    @BindableState var focusedField: Field? = .input
    
    enum Field: String, Hashable {
        case input
    }
}

enum InputAction: BindableAction {
    case binding(BindingAction<InputState>)
    case submit(String)
    case dismissKeyboard
    case focusInputField
}

struct InputEnvironment {
    var mainQueue: () -> AnySchedulerOf<DispatchQueue>
}

let inputReducer = Reducer<InputState, InputAction, InputEnvironment> { state, action, environment in
    struct TimerId: Hashable {}
    switch action {
    case .submit:
        guard !state.inputText.isEmpty else {
            return Effect(value: .dismissKeyboard)
        }
        
        state.inputText = ""
        return Effect(value: .focusInputField)
            .debounce(
                id: TimerId(),
                for: .milliseconds(100),
                scheduler: environment.mainQueue().eraseToAnyScheduler()
            )
        
    case .dismissKeyboard:
        state.focusedField = nil
        return .none
        
    case .focusInputField:
        state.focusedField = .input
        return .none
        
    case .binding(\.$inputText):
        return .none
        
    case .binding(\.$focusedField):
        return .none
        
    case .binding:
        return .none
    }
}.binding()

// MARK: - View

struct InputView: View {
    @FocusState var focusedField: InputState.Field?
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
                .focused($focusedField, equals: .input)
                .submitLabel(.done)
                .onSubmit {
                    withAnimation {
                        viewStore.send(.submit(viewStore.inputText))
                    }
                }
                
                Spacer()
                
                if focusedField != nil {
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
            .synchronize(viewStore.binding(\.$focusedField), self.$focusedField)
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
                environment: InputEnvironment(mainQueue: { .main })
            )
        )
    }
}
