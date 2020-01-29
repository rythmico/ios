import Foundation
import FirebaseAuth
import Sugar

public protocol AuthenticationAccessTokenProvider {
    typealias AccessToken = String
    typealias Error = AuthenticationCommonError
    typealias AccessTokenResult = Result<AccessToken, Error>
    func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>)
}

extension FirebaseAuth.User: AuthenticationAccessTokenProvider {
    public func getAccessToken(completionHandler: @escaping Handler<AccessTokenResult>) {
        getIDToken { token, error in
            switch (token, error) {
            case let (token?, _):
                completionHandler(.success(token))
            case let (_, (nsError as NSError)?):
                completionHandler(.failure(.init(nsError: nsError)))
            case (nil, nil):
                fatalError("No token or error received from Firebase")
            }
        }
    }
}
