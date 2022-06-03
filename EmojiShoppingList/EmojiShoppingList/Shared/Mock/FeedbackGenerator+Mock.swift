import UIKit
@testable import Shopping_List

extension FeedbackGenerator {
    static let mock: (_ mock: MockFeedbackGenerator?) -> FeedbackGenerator = { mock in
        guard let mock = mock else {
            return FeedbackGenerator(
                impact: { _ in fatalError("Mock not implemented") },
                notify: { _ in fatalError("Mock not implemented") }
            )
        }
        
        return FeedbackGenerator(
            impact: mock.impact,
            notify: mock.notify
        )
    }
}

final class MockFeedbackGenerator {
    
    var invokedImpact = false
    var invokedImpactCount = 0
    var invokedImpactParameters: (feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle, Void)?
    var invokedImpactParametersList = [(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle, Void)]()
    
    func impact(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        invokedImpact = true
        invokedImpactCount += 1
        invokedImpactParameters = (feedbackStyle, ())
        invokedImpactParametersList.append((feedbackStyle, ()))
    }
    
    var invokedNotify = false
    var invokedNotifyCount = 0
    var invokedNotifyParameters: (feedbackType: UINotificationFeedbackGenerator.FeedbackType, Void)?
    var invokedNotifyParametersList = [(feedbackType: UINotificationFeedbackGenerator.FeedbackType, Void)]()
    
    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        invokedNotify = true
        invokedNotifyCount += 1
        invokedNotifyParameters = (feedbackType, ())
        invokedNotifyParametersList.append((feedbackType, ()))
    }
}
