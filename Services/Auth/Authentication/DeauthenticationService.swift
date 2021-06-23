import FoundationSugar
import FirebaseAuth

protocol DeauthenticationServiceProtocol {
    func deauthenticate()
}

func DeauthenticationService() -> _DeauthenticationService { Auth.auth() }

typealias _DeauthenticationService = FirebaseAuth.Auth

extension _DeauthenticationService: DeauthenticationServiceProtocol {
    func deauthenticate() {
        try? signOut()
    }
}
