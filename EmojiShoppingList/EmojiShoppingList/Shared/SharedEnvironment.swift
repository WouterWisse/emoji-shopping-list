import ComposableArchitecture

@dynamicMemberLookup
struct SharedEnvironment<Environment> {
    var environment: Environment
    
    var mainQueue: () -> AnySchedulerOf<DispatchQueue>
    var feedbackGenerator: () -> FeedbackGenerator
}

// MARK: Environments

extension SharedEnvironment {
    static func live(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            feedbackGenerator: { .default() }
        )
    }
    
    static func mock(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            feedbackGenerator: { .mock }
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
