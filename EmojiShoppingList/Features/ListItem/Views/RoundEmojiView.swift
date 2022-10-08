import SwiftUI
import ComposableArchitecture

struct RoundEmojiView: View {
    let item: ListItem
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let size: CGFloat = 50
    
    var body: some View {
        Text(item.emoji)
            .font(.empoji)
            .multilineTextAlignment(.center)
            .frame(width: size, height: size, alignment: .center)
            .background(item.isDone ? .clear : item.color.emojiBackgroundOpacity(for: colorScheme))
            .cornerRadius(size / 2)
            .overlay(
                Circle()
                    .strokeBorder(
                        item.isDone ? .clear : item.color.emojiBorderOpacity(for: colorScheme),
                        lineWidth: 2
                    )
            )
    }
}

struct RoundEmojiView_Previews: PreviewProvider {
    static let colorSchemes: [ColorScheme] = [.light, .dark]
    
    static var previews: some View {
        ForEach(colorSchemes, id: \.self) { colorScheme in
            Group {
                RoundEmojiView(item: .preview)
                    .preferredColorScheme(colorScheme)
                    .previewLayout(.sizeThatFits)
                    .padding()
            }
        }
    }
}
