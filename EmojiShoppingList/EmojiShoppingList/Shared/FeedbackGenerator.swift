import UIKit

struct FeedbackGenerator {
    var impact: (_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) -> Void
    var notify: (_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) -> Void
}

extension FeedbackGenerator {
    static let `default`: () -> FeedbackGenerator = {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        return FeedbackGenerator(
            impact: { feedbackStyle in
                UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
            },
            notify: { feedbackType in
                notificationFeedbackGenerator.notificationOccurred(feedbackType)
            }
        )
    }
}

extension FeedbackGenerator {
    static let mock: FeedbackGenerator  = FeedbackGenerator(
        impact: { _ in },
        notify: { _ in }
    )
}
