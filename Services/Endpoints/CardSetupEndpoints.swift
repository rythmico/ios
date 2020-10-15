import APIKit

struct GetCardSetupCredentialRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/card-setup"

    typealias Response = CardSetupCredential
    typealias Error = RythmicoAPIError
}
