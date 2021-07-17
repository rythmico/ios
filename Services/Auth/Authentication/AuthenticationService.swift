import FoundationSugar
import FirebaseAuth

protocol AuthenticationServiceProtocol {
    typealias Response = UserCredentialProtocol
    typealias Error = AuthenticationError<AuthenticationErrorSignInReasonCode>
    typealias AuthenticationResult = Result<Response, Error>
    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>)
}

func AuthenticationService() -> _AuthenticationService { Auth.auth() }

typealias _AuthenticationService = FirebaseAuth.Auth

extension _AuthenticationService: AuthenticationServiceProtocol {
    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {
        let oauthCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: credential.identityToken,
            rawNonce: credential.nonce
        )
        signIn(with: oauthCredential) { authResult, error in
            switch (authResult, error) {
            case let (authResult?, _):
                // TODO: this is an affordance that does not belong here, violates SRP,
                // and should be extracted to its own class in charge of updating user details.
                // For now, impact is small enough that I can justify leaving it here.
                if let fullName = credential.fullName, authResult.user.displayName.isNilOrEmpty {
                    let userProfileChangeRequest = authResult.user.createProfileChangeRequest()
                    userProfileChangeRequest.displayName = fullName
                    userProfileChangeRequest.commitChanges { _ in
                        completionHandler(.success(authResult.user))
                    }
                } else {
                    completionHandler(.success(authResult.user))
                }
            case let (_, error?):
                completionHandler(.failure(.init(underlyingError: error)))
            case (nil, nil):
                preconditionFailure("No authResult or error received from Firebase")
            }
        }
    }
}
