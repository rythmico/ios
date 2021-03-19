import AuthenticationServices
import FoundationSugar

/// Type-safe, closure-based `ASAuthorizationControllerDelegate` wrapper to be used only internally by `AppleAuthorizationService`.
final class AppleAuthorizationCompletionDelegate: NSObject {
    typealias CompletionHandler = ResultHandler<AppleAuthorizationResponseProtocol, ASAuthorizationError>

    let authorizationCompletionHandler: CompletionHandler

    init(authorizationCompletionHandler: @escaping CompletionHandler) {
        self.authorizationCompletionHandler = authorizationCompletionHandler
    }
}

extension AppleAuthorizationCompletionDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let credential = authorization.credential as? ASAuthorizationAppleIDCredential !! preconditionFailure(
            "ASAuthorizationControllerDelegate received an authorization value of type other than expected ASAuthorizationAppleIDCredential"
        )
        authorizationCompletionHandler(.success(credential))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let error = error as? ASAuthorizationError !! preconditionFailure(
            "ASAuthorizationControllerDelegate received an error of type other than expected ASAuthorizationError"
        )
        authorizationCompletionHandler(.failure(error))
    }
}
