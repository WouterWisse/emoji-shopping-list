import Foundation
import ComposableArchitecture

@dynamicMemberLookup
struct SharedEnvironment<Environment> {
    var environment: Environment
    
    var mainQueue: () -> AnySchedulerOf<DispatchQueue>
    var persistence: () -> PersistenceController
    var feedbackGenerator: () -> FeedbackGenerator
}

// MARK: Environments

extension SharedEnvironment {
    static func live(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            persistence: { .default },
            feedbackGenerator: { .default() }
        )
    }
    
    static func preview(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            persistence: { .preview },
            feedbackGenerator: { .default() }
        )
    }
}

// MARK: Subscript

extension SharedEnvironment {
    subscript<Dependency>(
        dynamicMember keyPath: WritableKeyPath<Environment, Dependency>
    ) -> Dependency {
        get { self.environment[keyPath: keyPath] }
        set { self.environment[keyPath: keyPath] = newValue }
    }
}
