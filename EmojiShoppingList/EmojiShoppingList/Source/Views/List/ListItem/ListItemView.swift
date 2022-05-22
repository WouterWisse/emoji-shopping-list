import SwiftUI

struct ListItemView: View {
    let item: Item
    
    @State private var amount: Int = 1
    
    
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
                    .tint(item.color)
                    
                    Text("\(self.amount)")
                    .font(.headline)
                    .foregroundColor(item.color)
                    .frame(width: 30, height: 20, alignment: .center)
                    
                    RoundStepperButtonView(
                        title: "+",
                        action: increase
                    )
                    .tint(item.color)
                }
            }
        }
        .padding(.vertical, 8)
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
