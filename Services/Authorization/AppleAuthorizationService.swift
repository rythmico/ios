import AuthenticationServices
import CryptoKit

protocol AppleAuthorizationServiceProtocol {
    typealias Credential = AppleAuthorizationCredential
    typealias Error = ASAuthorizationError
    typealias AuthorizationResult = Result<Credential, Error>

    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>)
}

extension AppleAuthorizationServiceProtocol {
    func requestAuthorization(completionHandler: @escaping Handler<AuthorizationResult>) {
        requestAuthorization(nonce: UUID().uuidString, completionHandler: completionHandler)
    }
}

final class AppleAuthorizationService: AppleAuthorizationServiceProtocol {
    private var delegate: AppleAuthorizationCompletionDelegate!
    private let controllerType: AppleAuthorizationControllerProtocol.Type

    init(controllerType: AppleAuthorizationControllerProtocol.Type) {
        self.controllerType = controllerType
    }

    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = SHA256.hashString(utf8String: nonce)

        let controller = controllerType.init(authorizationRequests: [request])
        delegate = AppleAuthorizationCompletionDelegate { result in
            switch result {
            case .success(let credential):
                guard let identityToken = credential.identityToken else {
                    let error = ASAuthorizationError(.invalidResponse, userInfo: ["details": "Credential of type ASAuthorizationAppleIDCredential returned unexpected nil value for identityToken property."])
                    completionHandler(.failure(error))
                    return
                }
                let identityTokenString = String(decoding: identityToken, as: UTF8.self)
                let credential = Credential(identityToken: identityTokenString, nonce: nonce)
                completionHandler(.success(credential))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        controller.delegate = delegate
        controller.performRequests()
    }
}
