import Foundation

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
