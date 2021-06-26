import SwiftUISugar
import Combine

final class RootViewFlow: Flow {
    enum Step: FlowStep, CaseIterable {
        case onboarding
        case mainView
    }

    @Published private(set) var step: Step

    init(userCredentialProvider provider: UserCredentialProviderBase = Current.userCredentialProvider) {
        func step(for user: UserCredentialProtocol?) -> Step {
            user == nil ? .onboarding : .mainView
        }

        self.step = step(for: provider.userCredential)
        provider.$userCredential.map(step).assign(to: &$step)
    }
}
