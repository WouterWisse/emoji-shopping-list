import ComposableArchitecture
@testable import Shopping_List

extension SharedEnvironment {
    static func mock(
        environment: Environment,
        mainQueue: AnySchedulerOf<DispatchQueue>,
        persistenceController: MockPersistenceController,
        feedbackGenerator: MockFeedbackGenerator
    ) -> Self {
        Self(
            environment: environment,
            mainQueue: { mainQueue },
            persistenceController: { .mock(persistenceController) },
            feedbackGenerator: { .mock(feedbackGenerator) }
        )
    }
}
