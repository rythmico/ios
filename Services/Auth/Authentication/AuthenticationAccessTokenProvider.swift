import Foundation
import FirebaseAuth
import FoundationSugar

protocol AuthenticationAccessTokenProvider: AnyObject {
    var userId: String { get }

    typealias AccessToken = String
    typealias Error = AuthenticationCommonError
    typealias AccessTokenResult = Result<AccessToken, Error>
    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>)
}

extension FirebaseAuth.User: AuthenticationAccessTokenProvider {
    var userId: String { uid }

    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {
        getIDToken { token, error in
            switch (token, error) {
            case let (token?, _):
                completionHandler(.success(token))
            case let (_, (nsError as NSError)?):
                completionHandler(.failure(.init(nsError: nsError)))
            case (nil, nil):
                preconditionFailure("No token or error received from Firebase")
            }
        }
    }
}
