import Foundation
import ComposableArchitecture

@testable import Shopping_List

extension SharedEnvironment {
    static func mock(
        environment: Environment,
        mainQueue: AnySchedulerOf<DispatchQueue>,
        persistence: MockPersistenceController,
        feedbackGenerator: MockFeedbackGenerator
    ) -> Self {
        Self(
            environment: environment,
            mainQueue: { mainQueue },
            persistence: { .mock(persistence) },
            feedbackGenerator: { .mock(feedbackGenerator) }
        )
    }
}
