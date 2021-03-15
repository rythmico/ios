import Foundation
import FoundationSugar

final class AuthenticationServiceStub: AuthenticationServiceProtocol {
    var result: AuthenticationResult
    var delay: TimeInterval?

    init(result: AuthenticationResult, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {
        let work = { [self] in
            completionHandler(result)

            // Imitate Firebase's singleton behavior.
            switch result {
            case .success(let userCredential):
                Current.userCredentialProvider.userCredential = userCredential
            case .failure:
                break
            }
        }

        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
        } else {
            work()
        }
    }
}

final class AuthenticationServiceDummy: AuthenticationServiceProtocol {
    func authenticateAppleAccount(with credential: AppleAuthorizationCredential, completionHandler: @escaping Handler<AuthenticationResult>) {}
}
