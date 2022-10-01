import SwiftUI
import TextToEmoji

struct Emoji {
    let emoji: String
    let color: UIColor
}

struct EmojiProvider {
    var emoji: (_ title: String) async throws -> Emoji
}

extension EmojiProvider {
    static let `default`: EmojiProvider = {
        let textToEmoji = TextToEmoji()
        
        return EmojiProvider(
            emoji: { title in
                let emoji = try await textToEmoji.emoji(for: title, preferredCategory: .foodAndDrink) ?? "🤷🏼‍♂️"
                let color = emoji.toImage()?.averageColor?.adjust(brightness: 0.55) ?? .gray
                return Emoji(emoji: emoji, color: color)
            }
        )
    }()
}
