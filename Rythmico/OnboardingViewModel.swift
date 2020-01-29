import Foundation
import Combine
import Auth

protocol OnboardingViewModelProtocol: ViewModel where ViewData == OnboardingViewData {
    func showAppleAuthenticationSheet()
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    let objectWillChange = ObservableObjectPublisher()

    private(set) var viewData = OnboardingViewData() {
        willSet { dispatchQueue?.async(execute: objectWillChange.send) ?? objectWillChange.send() }
    }

    private let appleAuthorizationService: AppleAuthorizationServiceProtocol
    private let authenticationService: AuthenticationServiceProtocol
    private let keychain: KeychainProtocol
    private let dispatchQueue: DispatchQueue?

    init(
        appleAuthorizationService: AppleAuthorizationServiceProtocol,
        authenticationService: AuthenticationServiceProtocol,
        keychain: KeychainProtocol,
        dispatchQueue: DispatchQueue?
    ) {
        self.appleAuthorizationService = appleAuthorizationService
        self.authenticationService = authenticationService
        self.keychain = keychain
        self.dispatchQueue = dispatchQueue
    }

    func showAppleAuthenticationSheet() {
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
        let errorMessage: String?
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
        viewData.errorMessage = errorMessage
    }
}
