import SwiftUI
import Combine

final class RootViewFlow: Flow {
    enum Step: CaseIterable, Numbered, Countable {
        case onboarding
        case tutorStatus
        case mainView
    }

    private let userCredentialProvider: UserCredentialProviderBase
    private let settings: UserDefaults
    private var cancellable: AnyCancellable?

    init(
        userCredentialProvider: UserCredentialProviderBase = Current.userCredentialProvider,
        settings: UserDefaults = Current.settings
    ) {
        self.userCredentialProvider = userCredentialProvider
        self.settings = settings

        cancellable = Publishers.CombineLatest(
            userCredentialProvider.$userCredential,
            settings.publisher(for: \.tutorVerified)
        )
        .map { (isAuthenticated: $0 != nil, isTutorVerified: $1) }
        .map(stepForState)
        .removeDuplicates()
        .scan((previousStep, currentStep), { ($0.1, $1) })
        .sink { [self] previous, current in
            previousStep = previous
            currentStep = current
        }
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

    @Published private(set) var previousStep: Step?
    @Published private(set) var currentStep: Step = .onboarding
}
