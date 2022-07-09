import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct SettingsState: Equatable {
    var isPresented: Bool = false
    @BindableState var listNameInput: String = ""
    var colorTheme: ColorTheme = .primary
    var colorThemeState = ColorThemeState()
}

enum SettingsAction: BindableAction, Equatable {
    case binding(BindingAction<SettingsState>)
    case submit
    case onAppear
    case setColorTheme(isPresented: Bool)
    case colorThemeAction(ColorThemeAction)
}

struct SettingsEnvironment {}

let settingsReducer = Reducer<
    SettingsState,
    SettingsAction,
    SharedEnvironment<SettingsEnvironment>
>.combine(
    colorThemeReducer.pullback(
        state: \.colorThemeState,
        action: /SettingsAction.colorThemeAction,
        environment: { _ in .live(environment: ColorThemeEnvironment()) }
    ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            guard let name = environment.settingsPersistence().setting(.listName) as? String else {
                state.listNameInput = "Shopping List"
                return .none
            }
            
            state.listNameInput = name
            return .none
            
        case .submit:
            environment.settingsPersistence().saveSetting(state.listNameInput, .listName)
            return .none
            
        case .setColorTheme(let isPresented):
            state.colorThemeState.isPresented.toggle()
            return .none
            
        case .colorThemeAction(let action):
            return .none
            
        case .binding:
            return .none
        }
    }
)
.binding()
.debug()

// MARK: - View

struct SettingsView: View {
    let store: Store<SettingsState, SettingsAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Section("Settings") {
                        HStack(spacing: 12) {
                            RoundEmojiView(
                                emoji: "✏️",
                                color: .yellow,
                                done: false
                            )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                TextField(
                                    viewStore.listNameInput,
                                    text: viewStore.binding(\.$listNameInput),
                                    prompt: Text("Shopping List")
                                )
                                .font(.headline)
                                .foregroundColor(.primary)
                                .submitLabel(.done)
                                .onSubmit {
                                    viewStore.send(.submit)
                                }
                                
                                Text("Change the name of the list")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Button {
                            viewStore.send(.setColorTheme(isPresented: true))
                        } label: {
                            SettingsItemListView(
                                emoji: viewStore.colorTheme.emoji,
                                color: viewStore.colorTheme.color,
                                title: "Theme",
                                subtitle: "Change the appearance of the app"
                            )
                        }
                    }
                
                    Section("Support") {
                        SettingsItemListView(
                            emoji: "🤩",
                            color: .yellow,
                            title: "Rate on AppStore",
                            subtitle: "Let me know what you think!"
                        )
                    }
                    
                    DeveloperView()
                        .listRowBackground(Color.clear)
                    
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .sheet(isPresented: viewStore.binding(
                    get: { $0.colorThemeState.isPresented },
                    send:  SettingsAction.setColorTheme(isPresented:))
                ) {
                    ColorThemeView(
                        store: self.store.scope(
                            state: \.colorThemeState,
                            action: SettingsAction.colorThemeAction
                        )
                    )
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Settings")
            }
        }
    }
}

private struct SettingsItemListView: View {
    let emoji: String
    let color: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundEmojiView(
                emoji: emoji,
                color: color,
                done: false
            )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

private struct DeveloperView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Developed with 💙")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button {
                UIApplication.shared.open(URL(string: "http://www.twitter.com/wouterwisse")!)
            } label: {
                Text("👨🏼‍💻 @WouterWisse")
                    .font(.caption)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: Preview

struct SettingsView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            SettingsView(
                store: Store(
                    initialState: SettingsState(),
                    reducer: settingsReducer,
                    environment: .preview(
                        environment: SettingsEnvironment()
                    )
                )
            )
            .preferredColorScheme(colorScheme)
        }
    }
}
