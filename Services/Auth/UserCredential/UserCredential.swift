import FoundationEncore
import CoreDTO

struct UserCredential: Codable, Equatable {
    var userID: String
    var accessToken: String
}

extension UserCredential {
    init(_ siwaResponse: SIWAResponse) {
        self.init(
            userID: siwaResponse.userID,
            accessToken: siwaResponse.accessToken
        )
    }
}
