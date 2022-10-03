import Foundation
import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct InputState: Equatable {}

enum InputAction: Equatable {
    case submit(title: String)
    case dismissKeyboard
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
        environment.feedbackGenerator().impact(.soft)
        return .none
    }
}
.debug()

// MARK: - View

struct InputView: View {
    let store: Store<InputState, InputAction>
    
    @State var inputText: String = ""
    @FocusState var isFieldFocused: Bool
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack(spacing: .horizontalMargin) {
                TextField(
                    "Add to list...",
                    text: $inputText,
                    onCommit: {
                        withAnimation { isFieldFocused = !inputText.isEmpty }
                    }
                )
                .onSubmit {
                    if !inputText.isEmpty {
                        viewStore.send(.submit(title: inputText))
                        inputText = ""
                    }
                }
                .font(.default)
                .focused($isFieldFocused)
                .submitLabel(.done)
                
                Spacer()
                
                if isFieldFocused {
                    Button {
                        viewStore.send(.dismissKeyboard)
                        if inputText.isEmpty {
                            withAnimation { isFieldFocused = false }
                        } else {
                            inputText = ""
                        }
                    } label: {
                        HStack {
                            Image(
                                systemName: inputText.isEmpty
                                ? "checkmark.circle.fill"
                                : "xmark.circle.fill"
                            )
                            Text(
                                inputText.isEmpty
                                ? "Done"
                                : "Clear"
                            )
                            .font(.default)
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(inputText.isEmpty ? .green : .swipeDelete)
                }
            }
            .alignmentGuide(.listRowSeparatorLeading) {
                $0[.leading]
            }
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
                        initialState: InputState(),
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
