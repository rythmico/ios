import SwiftUI
import Combine

final class RootViewFlow: Flow {
    enum Step: CaseIterable, Numbered, Countable {
        case onboarding
        case mainView
    }

    private let userCredentialProvider: UserCredentialProviderBase
    private var cancellable: AnyCancellable?

    init(
        userCredentialProvider: UserCredentialProviderBase = Current.userCredentialProvider
    ) {
        self.userCredentialProvider = userCredentialProvider

        cancellable = userCredentialProvider.$userCredential
            .map { $0 != nil }
            .map(stepForState)
            .removeDuplicates()
            .scan((previousStep, currentStep), { ($0.1, $1) })
            .sink { [self] previous, current in
                previousStep = previous
                currentStep = current
            }
    }

    private func stepForState(isAuthenticated: Bool) -> Step {
        switch (isAuthenticated) {
        case false:
            return .onboarding
        case true:
            return .mainView
        }
    }

    @Published private(set) var previousStep: Step?
    @Published private(set) var currentStep: Step = .onboarding
}
