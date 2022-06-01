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
    
    @State var isSheetPresented: Bool = false
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Section("Settings") {
                        SettingsItemListView(emoji: "🔧", color: .gray, title: "Settings")
                        SettingsItemListView(emoji: "🤩", color: .yellow, title: "Rate on AppStore")
                        
                        Button {
                            isSheetPresented.toggle()
                        } label: {
                            SettingsItemListView(emoji: "👨🏼‍💻", color: .blue, title: "About the app")
                        }
                    }
                    
                    Section("Consider a donation") {
                        DonateListView(emoji: "🍏", color: .green, title: "Buy me an apple", price: "$0.99")
                        DonateListView(emoji: "☕️", color: .brown, title: "Buy me a coffee", price: "$2.99")
                        DonateListView(emoji: "🍺", color: .yellow, title: "Buy me a beer", price: "$4.99")
                    }
                }
                .sheet(isPresented: $isSheetPresented) {
                    AboutTheAppView()
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

struct AboutTheAppView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
            Image("Icon")
                .resizable()
                .frame(width: 124, height: 124, alignment: .center)
                .cornerRadius(24)
                
                Text("Emoji Shopping List")
                    .font(.headline)
                Text("Super simple & fun shopping list that links emoji to products.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                Spacer()
                    .frame(height: 20, alignment: .center)
            
                Text("Developed with ❤️ by")
                    .font(.caption)
                
            Button {
                UIApplication.shared.open(URL(string: "http://www.twitter.com/wouterwisse")!)
            } label: {
                Text("👨🏼‍💻 @WouterWisse")
                    .font(.headline)
            }
            .tint(.blue)
            .buttonStyle(.bordered)
            .controlSize(.regular)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .navigationTitle("About")
        }
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
