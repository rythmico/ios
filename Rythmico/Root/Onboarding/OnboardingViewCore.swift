import CoreDTO
import SwiftUIEncore

extension OnboardingView {
    func authenticateWithApple() {
        Current.siwaAuthorizationService.requestAuthorization { result in
            switch result {
            case .success(let credential):
                if Current.keychain.siwaUserInfo?.userID != credential.userInfo.userID {
                    Current.keychain.siwaUserInfo = credential.userInfo
                }
                let siwaBody = SIWABody(
                    name: Current.keychain.siwaUserInfo?.name ?? credential.userInfo.name,
                    jwt: credential.identityToken
                )
                coordinator.runToIdle(with: SIWARequest(body: siwaBody))
            case .failure(let error):
                handleAuthorizationError(error)
            }
        }
    }

    private func handleAuthorizationError(_ error: SIWAAuthorizationService.Error) {
        switch error.code {
        case .notHandled:
            preconditionFailure(error.legibleDescription)
        case .failed, .invalidResponse, .unknown:
            authorizationErrorMessage = error.legibleLocalizedDescription
        case .canceled:
            break
        case .notInteractive:
            break
        @unknown default:
            break
        }
    }

    func handleAuthenticationSuccess(_ siwaResponse: SIWAResponse) {
        Current.userCredentialProvider.userCredential = UserCredential(siwaResponse)
    }
}
