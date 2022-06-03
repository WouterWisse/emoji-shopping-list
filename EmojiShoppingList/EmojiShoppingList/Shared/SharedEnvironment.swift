import ComposableArchitecture

@dynamicMemberLookup
struct SharedEnvironment<Environment> {
    var environment: Environment
    
    var mainQueue: () -> AnySchedulerOf<DispatchQueue>
    var settingsPersistence: () -> SettingsPersistence
    var feedbackGenerator: () -> FeedbackGenerator
}

// MARK: Environments

extension SharedEnvironment {
    static func live(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            settingsPersistence: { .default },
            feedbackGenerator: { .default() }
        )
    }
    
    static func mock(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            settingsPersistence: { .default },
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
