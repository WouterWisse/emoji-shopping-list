import Foundation
@testable import Shopping_List

extension SharedEnvironment {
    static func mock(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            settingsPersistence: { .default },
            feedbackGenerator: { .mock(MockFeedbackGenerator()) }
        )
    }
}
