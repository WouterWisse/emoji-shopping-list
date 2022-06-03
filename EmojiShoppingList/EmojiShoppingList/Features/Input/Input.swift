import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct InputState: Equatable {
    @BindableState var inputText: String = ""
    @BindableState var focusedField: Field?
    var isFirstFieldFocus: Bool = true
    
    enum Field: String, Hashable {
        case input
    }
}

enum InputAction: BindableAction, Equatable {
    case binding(BindingAction<InputState>)
    case submit(String)
    case dismissKeyboard
    case prepareForNextItem
}

struct InputEnvironment {}

let inputReducer = Reducer<
    InputState,
    InputAction,
    SharedEnvironment<InputEnvironment>
> { state, action, environment in
    struct TimerId: Hashable {}
    switch action {
    case .submit:
        return .none
        
    case .dismissKeyboard:
        state.focusedField = nil
        return .none
        
    case .prepareForNextItem:
        state.isFirstFieldFocus = false
        state.inputText = ""
        return .none
        
    case .binding:
        return .none
    }
}.binding()

// MARK: - View

struct InputView: View {
    let store: Store<InputState, InputAction>
    
    @FocusState var focusedField: InputState.Field?
    
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
                .onChange(of: focusedField) { _ in
                    if viewStore.state.inputText.isEmpty && !viewStore.isFirstFieldFocus {
                        focusedField = nil
                    } else {
                        focusedField = .input
                        viewStore.send(.prepareForNextItem)
                    }
                }
                
                Spacer()
                
                if viewStore.focusedField != nil {
                    Button {
                        withAnimation {
                            viewStore.send(.dismissKeyboard)
                        }
                    } label: {
                        Image(systemName: viewStore.inputText.isEmpty ? "checkmark.circle.fill": "xmark.circle.fill")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                    .tint(viewStore.inputText.isEmpty ? .green : .red)
                }
            }
            .synchronize(viewStore.binding(\.$focusedField), self.$focusedField)
            .listRowSeparatorTint(.clear)
        }
    }
}

// MARK: - Preview

struct InputView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    static let inputTexts: [String] = ["", "Avocado"]
    static var previews: some View {
        ForEach(inputTexts, id: \.self) { inputText in
            ForEach(colorSchemes, id: \.self) { colorScheme in
                InputView(
                    store: Store(
                        initialState: InputState(
                            inputText: inputText,
                            focusedField: .input
                        ),
                        reducer: inputReducer,
                        environment: .preview(environment: InputEnvironment())
                    )
                )
                .preferredColorScheme(colorScheme)
                .previewLayout(.sizeThatFits)
                .padding()
            }
        }
    }
}
