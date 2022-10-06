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
    
    @State private var inputText: String = ""
    @FocusState private var focusedField: FocusedField?
    
    enum FocusedField {
        case input
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                TextField("Add to list...", text: $inputText)
                    .onSubmit {
                        if inputText.isEmpty {
                            focusedField = nil
                        } else {
                            focusedField = .input
                            viewStore.send(.submit(title: inputText))
                            inputText = ""
                        }
                    }
                    .font(.listItem)
                    .focused($focusedField, equals: .input)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                
                Spacer()
                
                Button {
                    viewStore.send(.dismissKeyboard)
                    if inputText.isEmpty {
                        withAnimation { focusedField = nil }
                    } else {
                        inputText = ""
                    }
                } label: {
                    Image(
                        systemName: inputText.isEmpty
                        ? "checkmark.circle.fill"
                        : "xmark.circle.fill"
                    )
                    .font(.default)
                }
                .disabled(focusedField != .input)
                .buttonStyle(.bordered)
                .controlSize(.regular)
                .tint(inputText.isEmpty ? .green : .swipeDelete)
            }
            .frame(height: 44)
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
