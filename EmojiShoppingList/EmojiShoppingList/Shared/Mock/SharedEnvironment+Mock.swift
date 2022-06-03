import ComposableArchitecture
@testable import Shopping_List

extension SharedEnvironment {
    static func mock(
        environment: Environment,
        mainQueue: AnySchedulerOf<DispatchQueue>,
        settingsPersistence: MockSettingsPerstence,
        feedbackGenerator: MockFeedbackGenerator
    ) -> Self {
        Self(
            environment: environment,
            mainQueue: { mainQueue },
            settingsPersistence: { .mock(settingsPersistence) },
            feedbackGenerator: { .mock(feedbackGenerator) }
        )
    }
}
