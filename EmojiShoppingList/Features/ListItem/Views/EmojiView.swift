import SwiftUI
import ComposableArchitecture

struct EmojiView: View {
    let item: ListItem
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let size: CGFloat = 50
    
    var body: some View {
        Text(item.emoji)
            .font(.emoji)
            .multilineTextAlignment(.center)
            .frame(width: size, height: size, alignment: .center)
            .background(item.completed ? .clear : item.color.emojiBackgroundOpacity(for: colorScheme))
            .cornerRadius(size / 2)
            .overlay(
                Circle()
                    .strokeBorder(
                        item.completed ? .clear : item.color.emojiBorderOpacity(for: colorScheme),
                        lineWidth: 2
                    )
            )
    }
}

struct EmojiView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            Group {
                EmojiView(item: .preview)
                    .preferredColorScheme(colorScheme)
                    .previewLayout(.sizeThatFits)
                    .padding()
            }
        }
    }
}
