import ComposableArchitecture

@dynamicMemberLookup
struct SharedEnvironment<Environment> {
    var environment: Environment
    
    var mainQueue: () -> AnySchedulerOf<DispatchQueue>
    var persistenceController: () -> PersistenceController
    var settingsPersistence: () -> SettingsPersistence
    var feedbackGenerator: () -> FeedbackGenerator
}

// MARK: Environments

extension SharedEnvironment {
    static func live(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            persistenceController: { .default },
            settingsPersistence: { .default },
            feedbackGenerator: { .default() }
        )
    }
    
    static func preview(environment: Environment) -> Self {
        Self(
            environment: environment,
            mainQueue: { .main },
            persistenceController: { .preview },
            settingsPersistence: { .default },
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
