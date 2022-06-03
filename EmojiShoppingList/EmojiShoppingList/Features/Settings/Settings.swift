import SwiftUI
import ComposableArchitecture

// MARK: - Logic

struct SettingsState: Equatable {
    var isPresented: Bool = false
}

enum SettingsAction {
    
}

struct SettingsEnvironment {}

let settingsReducer = Reducer<
    SettingsState,
    SettingsAction,
    SharedEnvironment<SettingsEnvironment>
> { state, action, environment in
    switch action {
        
    }
}
.debug()

// MARK: - View

struct SettingsView: View {
    let store: Store<SettingsState, SettingsAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Section {
                        SettingsItemListView(
                            emoji: "✏️",
                            color: .yellow,
                            title: "Shopping List",
                            reason: "Change the name of the list"
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
                            reason: "Sugar gives me energy",
                            price: "$0.99",
                            action: {}
                        )
                        DonateListView(
                            emoji: "☕️",
                            color: .green,
                            title: "Get me a coffee",
                            reason: "Caffeine keeps me awake",
                            price: "$2.99",
                            action: {}
                        )
                        DonateListView(
                            emoji: "🍺",
                            color: .green,
                            title: "Get me a beer",
                            reason: "Beer boosts my creativity",
                            price: "$4.99",
                            action: {}
                        )
                    } header: {
                    } footer: {
                        Text("Donations are highly appreciated and will fuel me to create new updates and features ✌️")
                            .multilineTextAlignment(.center)
                    }
                    
                    Section {
                        DeveloperView()
                            .listRowBackground(Color.clear)
                    }
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
                    environment: .mock(environment: SettingsEnvironment())
                )
            )
            .padding()
            .preferredColorScheme(colorScheme)
        }
    }
}
