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
    static let `default`: () -> EmojiProvider = {
        let fallbackEmoji = "🤷"
        let fallbackEmojiColor: UIColor = .gray
        
        return EmojiProvider(
            emoji: { title in
                do {
                    let emoji = try await TextToEmoji.emoji(for: title, preferredCategory: .foodAndDrink) ?? fallbackEmoji
                    let color = emoji.toImage()?.averageColor?.adjustBrightness(by: 0.55) ?? fallbackEmojiColor
                    return Emoji(emoji: emoji, color: color)
                } catch {
                    return Emoji(emoji: fallbackEmoji, color: fallbackEmojiColor)
                }
            }
        )
    }
}
