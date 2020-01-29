import Foundation
import FirebaseAuth

public protocol DeauthenticationServiceProtocol {
    func deauthenticate()
}

public func DeauthenticationService() -> _DeauthenticationService { Auth.auth() }

public typealias _DeauthenticationService = FirebaseAuth.Auth

extension _DeauthenticationService: DeauthenticationServiceProtocol {
    public func deauthenticate() {
        try? signOut()
    }
}

