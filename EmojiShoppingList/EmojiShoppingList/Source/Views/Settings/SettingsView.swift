import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    SettingsItemListView(emoji: "📱", color: .gray, title: "Change app icon")
                    SettingsItemListView(emoji: "🤩", color: .green, title: "Rate on AppStore")
                }

                Section("Consider a donation") {
                    DonateListView(emoji: "🍏", color: .green, title: "Buy me an apple", price: "$0.99")
                    DonateListView(emoji: "☕️", color: .green, title: "Buy me a coffee", price: "$2.99")
                    DonateListView(emoji: "🍺", color: .green, title: "Buy me a beer", price: "$4.99")
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
                            // Do something
                        } label: {
                            Text("🐦 @WouterWisse")
                        }
                        .tint(.blue)
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

struct SettingsItemListView: View {
    let emoji: String
    let color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundEmojiView(
                emoji: emoji,
                color: color
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
                color: color
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
            SettingsView()
                .padding()
                .preferredColorScheme(colorScheme)
        }
    }
}
