import SwiftUISugar
import Combine

final class RootViewFlow: Flow {
    enum Step: FlowStep, CaseIterable {
        case onboarding
        case tutorStatus
        case mainView
    }

    @Published private(set) var step: Step

    init(
        userCredentialProvider provider: UserCredentialProviderBase = Current.userCredentialProvider,
        settings: UserDefaults = Current.settings
    ) {
        func step(forUser user: UserCredentialProtocol?, isVerified: Bool) -> Step {
            let isAuthenticated = user != nil
            switch (isAuthenticated, isVerified) {
            case (false, _):
                return .onboarding
            case (true, false):
                return .tutorStatus
            case (true, true):
                return .mainView
            }
        }

        self.step = step(forUser: provider.userCredential, isVerified: settings.tutorVerified)
        Publishers.CombineLatest(provider.$userCredential, settings.publisher(for: \.tutorVerified)).map(step).assign(to: &$step)
    }
}
