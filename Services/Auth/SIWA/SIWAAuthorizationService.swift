import FoundationEncore
import AuthenticationServices
import CryptoKit

protocol SIWAAuthorizationServiceProtocol {
    typealias Credential = SIWACredential
    typealias Error = ASAuthorizationError
    typealias AuthorizationResult = Result<Credential, Error>

    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>)
}

extension SIWAAuthorizationServiceProtocol {
    func requestAuthorization(completionHandler: @escaping Handler<AuthorizationResult>) {
        requestAuthorization(nonce: UUID().uuidString, completionHandler: completionHandler)
    }
}

final class SIWAAuthorizationService: SIWAAuthorizationServiceProtocol {
    private var delegate: SIWAAuthorizationCompletionDelegate!
    private let controllerType: SIWAAuthorizationControllerProtocol.Type

    init(controllerType: SIWAAuthorizationControllerProtocol.Type) {
        self.controllerType = controllerType
    }

    func requestAuthorization(nonce: String, completionHandler: @escaping Handler<AuthorizationResult>) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = SHA256.hashString(utf8String: nonce)

        let controller = controllerType.init(authorizationRequests: [request])
        delegate = SIWAAuthorizationCompletionDelegate { result in
            switch result {
            case .success(let response):
                guard let identityToken = response.identityToken else {
                    let error = ASAuthorizationError(
                        _nsError: NSError(
                            domain: ASAuthorizationErrorDomain,
                            code: ASAuthorizationError.invalidResponse.rawValue,
                            localizedDescription: "ASAuthorizationAppleIDCredential.identityToken is unexpectedly nil."
                        )
                    )
                    completionHandler(.failure(error))
                    return
                }
                let credential = Credential(
                    userInfo: Credential.UserInfo(
                        userID: response.userID,
                        name: response.fullName.map(PersonNameComponentsFormatter().string(from:)),
                        email: response.email
                    ),
                    identityToken: String(decoding: identityToken, as: UTF8.self),
                    nonce: nonce
                )
                completionHandler(.success(credential))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        controller.delegate = delegate
        controller.performRequests()
    }
}
