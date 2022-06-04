import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct SettingsState: Equatable {
    var isPresented: Bool = false
    @BindableState var listNameInput: String = ""
}

enum SettingsAction: BindableAction, Equatable {
    case binding(BindingAction<SettingsState>)
    case submit
    case onAppear
}

struct SettingsEnvironment {}

let settingsReducer = Reducer<
    SettingsState,
    SettingsAction,
    SharedEnvironment<SettingsEnvironment>
> { state, action, environment in
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

    case .binding:
        return .none
    }
}
.binding()

// MARK: - View

struct SettingsView: View {
    let store: Store<SettingsState, SettingsAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Section {
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
                                .onSubmit {
                                    viewStore.send(.submit)
                                }
                                
                                Text("Change the name of the list")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                        SettingsItemListView(
                            emoji: "📱",
                            color: .green,
                            title: "Change app icon",
                            reason: "Just for fun",
                            locked: true
                        )
                    }
                    
                    Section {
                        SettingsItemListView(
                            emoji: "🤩",
                            color: .yellow,
                            title: "Rate on AppStore",
                            reason: "Let me know what you think!"
                        )
                        DonateListView(
                            emoji: "🍩",
                            color: .green,
                            title: "Get me a snack",
                            reason: "Gives me energy",
                            price: "$0.99",
                            action: {}
                        )
                        DonateListView(
                            emoji: "☕️",
                            color: .green,
                            title: "Get me a coffee",
                            reason: "Keeps me awake",
                            price: "$2.99",
                            action: {}
                        )
                        DonateListView(
                            emoji: "🍺",
                            color: .green,
                            title: "Get me a beer",
                            reason: "Boosts my creativity",
                            price: "$4.99",
                            action: {}
                        )
                    } header: {
                    } footer: {
                        VStack(spacing: 24) {
                            Text("Any of the above purchases will unlock the functionality to change the app's icon and will fuel me to create new features and updates. ✌️")
                            
                            DeveloperView()
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .listStyle(.insetGrouped)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Emoji Shopping List")
            }
        }
    }
}

struct SettingsItemListView: View {
    let emoji: String
    let color: Color
    let title: String
    let reason: String
    var locked: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            RoundEmojiView(
                emoji: locked ? "🔒" : emoji,
                color: locked ? .gray : color,
                done: false
            )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(locked ? .secondary : .primary)
                Text(locked ? "This functionality is locked" : reason)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct DonateListView: View {
    let emoji: String
    let color: Color
    let title: String
    let reason: String
    let price: String
    let action: () -> Void
    
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
                Text(reason)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                action()
            } label: {
                Text(price)
            }
            .tint(color)
            .buttonStyle(.bordered)
            .controlSize(.small)
            
        }
        .padding(.vertical, 8)
    }
}

struct DeveloperView: View {
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
