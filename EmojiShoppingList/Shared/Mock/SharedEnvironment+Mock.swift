import ComposableArchitecture
@testable import Shopping_List

extension SharedEnvironment {
    static func mock(
        environment: Environment,
        mainQueue: AnySchedulerOf<DispatchQueue>,
        persistenceController: MockPersistenceController,
        settingsPersistence: MockSettingsPerstence,
        feedbackGenerator: MockFeedbackGenerator
    ) -> Self {
        Self(
            environment: environment,
            mainQueue: { mainQueue },
            persistenceController: { .mock(persistenceController) },
            settingsPersistence: { .mock(settingsPersistence) },
            feedbackGenerator: { .mock(feedbackGenerator) }
        )
    }
}
