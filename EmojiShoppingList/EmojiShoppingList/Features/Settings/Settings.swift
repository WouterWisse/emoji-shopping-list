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

// MARK: - View

struct SettingsView: View {
    let store: Store<SettingsState, SettingsAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Section {
                        SettingsItemListView(emoji: "✏️", color: .yellow, title: "Change list name")
                        SettingsItemListView(emoji: "🤩", color: .yellow, title: "Rate on AppStore")
                    }
                    
                    Section("Consider a donation") {
                        DonateListView(emoji: "🍏", color: .green, title: "Buy me an apple", price: "$0.99")
                        DonateListView(emoji: "☕️", color: .brown, title: "Buy me a coffee", price: "$2.99")
                        DonateListView(emoji: "🍺", color: .yellow, title: "Buy me a beer", price: "$4.99")
                    }
                    
                    Section {
                        VStack {
                            Image("Icon")
                                .resizable()
                                .frame(width: 60, height: 60, alignment: .center)
                                .cornerRadius(12)
                            Text("1.0")
                                .font(.caption)
                            
                            Button {
                                UIApplication.shared.open(URL(string: "http://www.twitter.com/wouterwisse")!)
                            } label: {
                                Text("👨🏼‍💻 @WouterWisse")
                            }
                            .tint(.gray)
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .listRowBackground(Color.clear)
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
    
    var body: some View {
        HStack(spacing: 12) {
            RoundEmojiView(
                emoji: emoji,
                color: color,
                done: false
            )
            
            Text(title)
                .font(.headline)
        }
        .padding(.vertical, 8)
    }
}

struct DonateListView: View {
    let emoji: String
    let color: Color
    let title: String
    let price: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundEmojiView(
                emoji: emoji,
                color: color,
                done: false
            )
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Button {
                // Do something
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
