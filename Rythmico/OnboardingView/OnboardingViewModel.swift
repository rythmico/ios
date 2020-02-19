import Foundation
import ViewModel

final class OnboardingViewModel: ViewModelObject<OnboardingViewData> {
    private let appleAuthorizationService: AppleAuthorizationServiceProtocol
    private let authenticationService: AuthenticationServiceProtocol
    private let keychain: KeychainProtocol

    init(
        appleAuthorizationService: AppleAuthorizationServiceProtocol,
        authenticationService: AuthenticationServiceProtocol,
        keychain: KeychainProtocol
    ) {
        self.appleAuthorizationService = appleAuthorizationService
        self.authenticationService = authenticationService
        self.keychain = keychain
        super.init(viewData: .init())
    }

    func authenticateWithApple() {
        appleAuthorizationService.requestAuthorization { result in
            switch result {
            case .success(let credential):
                self.keychain.appleAuthorizationUserId = credential.userId
                self.viewData.isLoading = true
                self.authenticationService.authenticateAppleAccount(with: credential) { result in
                    self.viewData.isLoading = false
                    switch result {
                    case .success:
                        // Firebase's Auth singleton makes this line redundant since it's notifies listeners
                        // about user changes upon sign in. However if services are changed there's
                        // a chance this line might be needed.
                        // self.authenticationStatusObserver.statusDidChangeHandler(accessTokenProvider)
                        break
                    case .failure(let error):
                        self.handleAuthenticationError(error)
                    }
                }
            case .failure(let error):
                self.handleAuthorizationError(error)
            }
        }
    }

    func dismissErrorAlert() {
        viewData.errorAlertViewData = nil
    }

    private func handleAuthorizationError(_ error: AppleAuthorizationService.Error) {
        switch error.code {
        case .notHandled:
            preconditionFailure(error.localizedDescription)
        case .canceled, .failed, .invalidResponse, .unknown:
            break
        @unknown default:
            break
        }
    }

    private func handleAuthenticationError(_ error: AuthenticationServiceProtocol.Error) {
        let errorMessage: String
        switch error.reasonCode {
        case .invalidAPIKey,
             .appNotAuthorized,
             .internalError,
             .operationNotAllowed:
            preconditionFailure("\(error.localizedDescription) (\(error.reasonCode.rawValue))")
        case .unknown,
             .networkError,
             .tooManyRequests,
             .invalidCredential,
             .userDisabled,
             .invalidEmail,
             .missingOrInvalidNonce:
            errorMessage = "\(error.localizedDescription) (\(error.reasonCode.rawValue))"
        }
        viewData.errorAlertViewData = OnboardingViewData.ErrorAlertViewData(message: errorMessage)
    }
}
