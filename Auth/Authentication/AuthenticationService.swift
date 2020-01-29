import Foundation
import FirebaseAuth
import Sugar

public protocol AuthenticationServiceProtocol {
    typealias Response = AuthenticationAccessTokenProvider
    typealias Error = AuthenticationAPIError
    typealias AuthenticationResult = Result<Response, Error>
    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>)
}

public func AuthenticationService() -> _AuthenticationService { Auth.auth() }

public typealias _AuthenticationService = FirebaseAuth.Auth

extension _AuthenticationService: AuthenticationServiceProtocol {
    public func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {
        let oauthCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: credential.identityToken,
            rawNonce: credential.nonce
        )
        signIn(with: oauthCredential) { authResult, error in
            switch (authResult, error) {
            case let (authResult?, _):
                // This is an affordance that does not belong here, violates SRP,
                // and should be extracted to its own class in charge of updating user details.
                // For now, impact is small enough that I can justify leaving it here.
                if let fullName = credential.fullName, let email = credential.email {
                    let userProfileChangeRequest = authResult.user.createProfileChangeRequest()
                    userProfileChangeRequest.displayName = fullName
                    userProfileChangeRequest.commitChanges { _ in
                        authResult.user.updateEmail(to: email) { _ in
                            completionHandler(.success(authResult.user))
                        }
                    }
                } else {
                    completionHandler(.success(authResult.user))
                }
            case let (_, (nsError as NSError)?):
                completionHandler(.failure(.init(nsError: nsError)))
            case (nil, nil):
                preconditionFailure("No authResult or error received from Firebase")
            }
        }
    }
}
