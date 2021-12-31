import FoundationEncore
import AuthenticationServices

/// Type-safe, closure-based `ASAuthorizationControllerDelegate` wrapper to be used only internally by `SIWAService`.
final class SIWAAuthorizationCompletionDelegate: NSObject {
    typealias CompletionHandler = ResultHandler<SIWAAuthorizationResponseProtocol, ASAuthorizationError>

    let handler: CompletionHandler

    init(handler: @escaping CompletionHandler) {
        self.handler = handler
    }
}

extension SIWAAuthorizationCompletionDelegate: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let credential = authorization.credential as? ASAuthorizationAppleIDCredential !! preconditionFailure(
            "ASAuthorizationControllerDelegate received an authorization value of type other than expected ASAuthorizationAppleIDCredential"
        )
        handler(.success(credential))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let error = error as? ASAuthorizationError !! preconditionFailure(
            "ASAuthorizationControllerDelegate received an error of type other than expected ASAuthorizationError"
        )
        handler(.failure(error))
    }
}
