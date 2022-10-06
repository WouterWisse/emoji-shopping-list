import UIKit
@testable import Shopping_List

extension EmojiProvider {
    static let mock: (_ mock: MockEmojiProvider?) -> EmojiProvider = { mock in
        guard let mock = mock else {
            return EmojiProvider(
                emoji: { _ in fatalError("Mock not implemented") }
            )
        }
        
        return EmojiProvider(emoji: mock.emoji)
    }
}

final class MockEmojiProvider {

    var invokedEmoji = false
    var invokedEmojiCount = 0
    var invokedEmojiParameters: (title: String, Void)?
    var invokedEmojiParametersList = [(title: String, Void)]()
    var stubbedEmojiResult: Emoji!

    func emoji(_ title: String) -> Emoji {
        invokedEmoji = true
        invokedEmojiCount += 1
        invokedEmojiParameters = (title, ())
        invokedEmojiParametersList.append((title, ()))
        return stubbedEmojiResult
    }
}
