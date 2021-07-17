import FoundationSugar
import FirebaseAuth

protocol UserCredentialProtocol: AnyObject {
    var userId: String { get }
    var name: String? { get }
    var email: String? { get }

    typealias AccessToken = String
    typealias Error = AuthenticationCommonError
    typealias AccessTokenResult = Result<AccessToken, Error>
    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>)
}

extension FirebaseAuth.User: UserCredentialProtocol {
    var userId: String { uid }
    var name: String? { displayName }

    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {
        getIDToken { token, error in
            switch (token, error) {
            case let (token?, _):
                completionHandler(.success(token))
            case let (_, error?):
                completionHandler(.failure(.init(underlyingError: error)))
            case (nil, nil):
                preconditionFailure("No token or error received from Firebase")
            }
        }
    }
}
