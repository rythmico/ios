import SwiftUIEncore

extension OnboardingView {
    func authenticateWithApple() {
        Current.appleAuthorizationService.requestAuthorization { result in
            switch result {
            case .success(let credential):
                Current.keychain.appleAuthorizationUserId = credential.userId
                isLoading = true
                Current.authenticationService.authenticateAppleAccount(with: credential) { result in
                    isLoading = false
                    switch result {
                    case .success:
                        // Firebase's Auth singleton makes this line redundant since it notifies listeners
                        // about user changes upon sign in. However if services are changed there's
                        // a chance this line might be needed.
                        // authenticationStatusObserver.statusDidChangeHandler(userCredential)
                        break
                    case .failure(let error):
                        handleAuthenticationError(error)
                    }
                }
            case .failure(let error):
                handleAuthorizationError(error)
            }
        }
    }

    private func handleAuthorizationError(_ error: AppleAuthorizationService.Error) {
        switch error.code {
        case .notHandled:
            preconditionFailure(error.legibleDescription)
        case .failed, .invalidResponse, .unknown:
            errorMessage = error.legibleLocalizedDescription
        case .canceled:
            break
        case .notInteractive:
            break
        @unknown default:
            break
        }
    }

    private func handleAuthenticationError(_ error: AuthenticationSignInError) {
        switch error.reasonCode {
        case .invalidAPIKey,
             .appNotAuthorized,
             .internalError,
             .operationNotAllowed:
            preconditionFailure("\(error.underlyingError.legibleDescription) (\(error.reasonCode.rawValue))")
        case .unknown,
             .networkError,
             .tooManyRequests,
             .invalidCredential,
             .userDisabled,
             .invalidEmail,
             .missingOrInvalidNonce,
             .userTokenExpired:
            errorMessage = "\(error.underlyingError.legibleLocalizedDescription) (\(error.reasonCode.rawValue))"
        }
    }
}
