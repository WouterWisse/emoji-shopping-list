import SwiftUI

struct ListItemView: View {
    let item: Item
    
    @State private var amount: Int = 1
    
    private let backgroundColor: Color = .gray
    
    var body: some View {
        HStack(spacing: 12) {
            RoundEmojiView(
                emoji: item.emojiString,
                color: item.color
            )
            
            Text(item.title ?? "")
                .font(.headline)
                .strikethrough(item.done)
            
            Spacer()
            
            if !item.done {
                HStack(spacing: 4) {
                    RoundStepperButtonView(
                        title: "-",
                        action: decrease
                    )
                    
                    Text(
                        "\(self.amount)"
                    )
                    .font(.headline)
                    .frame(width: 30, height: 20, alignment: .center)
                    
                    RoundStepperButtonView(
                        title: "+",
                        action: increase
                    )
                }
            }
        }
    }
    
    private func increase() {
        Haptics.shared.play(.light)
        amount += 1
    }
    
    private func decrease() {
        Haptics.shared.play(.light)
        amount -= 1
    }
}

struct ListItemView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            ListItemView(item: PersistenceController.previewItem)
                .preferredColorScheme(colorScheme)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
