import Foundation
import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct InputState: Equatable {
    var isInputFocused: Bool = false
}

enum InputAction: Equatable {
    case submit(title: String)
    case focusDidChange(isFocused: Bool)
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
        
    case .focusDidChange(let isFocused):
        state.isInputFocused = isFocused
        return .none
    }
}
.debug()

// MARK: - View

struct InputView: View {
    let store: Store<InputState, InputAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack(alignment: .leading) {
                FocusedTextField(
                    onSubmit: { text in
                        viewStore.send(.submit(title: text), animation: .default)
                    },
                    focusDidChange: { isFocused in
                        viewStore.send(
                            .focusDidChange(isFocused: isFocused),
                            animation: .default
                        )
                    }
                )
                
                /*
                if !viewStore.isInputFocused {
                    InputPlaceholderView {
                        Text(#""Tofu""#)
                            .font(.default)
                            .foregroundColor(.secondary)
                    }
                    .padding([.leading, .trailing], 8)
                }
                 */
            }
        }
        .padding(.bottom, .margin.inputVertical)
        .alignmentGuide(.listRowSeparatorLeading) {
            $0[.leading]
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
