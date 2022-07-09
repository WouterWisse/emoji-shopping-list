import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct ColorThemeState: Equatable {
    var colorThemes: [ColorTheme] = ColorTheme.allCases
    var selectedColorTheme: ColorTheme = .primary
    var isPresented: Bool = false
}

enum ColorThemeAction: Equatable {
    case onAppear
    case didTapColorTheme(colorTheme: ColorTheme)
}

struct ColorThemeEnvironment {}

let colorThemeReducer = Reducer<
    ColorThemeState,
    ColorThemeAction,
    SharedEnvironment<ColorThemeEnvironment>
> { state, action, environment in
    switch action {
    case .onAppear:
        let colorTheme = environment.colorThemeProvider().theme()
        state.selectedColorTheme = colorTheme
        return .none
        
    case .didTapColorTheme(let colorTheme):
        environment.colorThemeProvider().selectTheme(colorTheme)
        state.selectedColorTheme = colorTheme
        return .none
    }
}
.debug()

// MARK: - View


struct ColorThemeView: View {
    let store: Store<ColorThemeState, ColorThemeAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Section("Options") {
                        ForEach(viewStore.colorThemes, id: \.rawValue) { colorTheme in
                            Button {
                                viewStore.send(.didTapColorTheme(colorTheme: colorTheme))
                            } label: {
                                ColorThemeRowView(
                                    colorTheme: colorTheme,
                                    isSelected: colorTheme == viewStore.selectedColorTheme
                                )
                            }
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Color Theme")
            }
        }
    }
}

private struct ColorThemeRowView: View {
    let colorTheme: ColorTheme
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            RoundEmojiView(
                emoji: colorTheme.emoji,
                color: colorTheme.color,
                done: false
            )
            
            Text(colorTheme.description)
                .font(.headline)
                .foregroundColor(colorTheme.color)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(colorTheme.color)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: Preview

struct ColorThemeView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            ColorThemeView(
                store: Store(
                    initialState: ColorThemeState(),
                    reducer: colorThemeReducer,
                    environment: .preview(
                        environment: ColorThemeEnvironment()
                    )
                )
            )
            .preferredColorScheme(colorScheme)
        }
    }
}
