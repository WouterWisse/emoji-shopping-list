import SwiftUI
import ComposableArchitecture

struct RoundEmojiView: View {
    let item: ListItem
    
    private let size: CGFloat = 50
    
    var body: some View {
        Text(item.emoji)
            .font(.title2)
            .multilineTextAlignment(.center)
            .frame(width: size, height: size, alignment: .center)
            .background(item.color.opacity(item.isDone ? 0 : 0.1))
            .cornerRadius(size / 2)
            .overlay(
                Circle()
                    .strokeBorder(
                        item.color.opacity(item.isDone ? 0 : 0.25),
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
                RoundEmojiView(item: ListItem.mock)
                    .preferredColorScheme(colorScheme)
                    .previewLayout(.sizeThatFits)
                    .padding()
            }
        }
    }
}
