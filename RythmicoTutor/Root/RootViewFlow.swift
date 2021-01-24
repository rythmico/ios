import SwiftUI
import Combine

final class RootViewFlow: Flow {
    enum Step: CaseIterable, Numbered, Countable {
        case onboarding
        case tutorStatus
        case mainView
    }

    private let accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase
    private let settings: UserDefaults
    private var cancellable: AnyCancellable?

    init(
        accessTokenProviderObserver: AuthenticationAccessTokenProviderObserverBase = Current.accessTokenProviderObserver,
        settings: UserDefaults = Current.settings
    ) {
        self.accessTokenProviderObserver = accessTokenProviderObserver
        self.settings = settings

        cancellable = Publishers.CombineLatest(
            accessTokenProviderObserver.$currentProvider,
            settings.publisher(for: \.tutorVerified)
        )
        .map { (isAuthenticated: $0 != nil, isTutorVerified: $1) }
        .map(stepForState)
        .assign(to: \.currentStep, on: self)
    }

    private func stepForState(isAuthenticated: Bool, isTutorVerified: Bool) -> Step {
        switch (isAuthenticated, isTutorVerified) {
        case (false, _):
            return .onboarding
        case (true, false):
            return .tutorStatus
        case (true, true):
            return .mainView
        }
    }

    private(set) var previousStep: Step?

    @Published var currentStep: Step = .onboarding {
        willSet { previousStep = currentStep }
    }
}
