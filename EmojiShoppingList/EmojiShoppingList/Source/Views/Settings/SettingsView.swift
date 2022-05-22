import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                VStack(spacing: 8) {
                    Image("Icon")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                    Text("Emoji Shopping List")
                        .font(.headline)
                    Text("1.0")
                        .font(.caption)
                }
                .listRowSeparatorTint(.clear)
                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200, alignment: .center)
                
                Group {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Consider a donation")
                            .font(.headline)
                        Text("Creating and maintaining an app is a lot of work. I have build this app for you, for free. But just like you, I also need to buy groceries. 😊")
                            .font(.caption)
                    }
                    .listRowSeparatorTint(.clear)
                    DonateListView(emoji: "🍏", color: .green, title: "Buy me an apple", price: "$0.99")
                    DonateListView(emoji: "☕️", color: .brown, title: "Buy me a coffee", price: "$2.99")
                    DonateListView(emoji: "🍺", color: .yellow, title: "Buy me a beer", price: "$4.99")
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Settings")
        }
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
    static var previews: some View {
        SettingsView()
    }
}
