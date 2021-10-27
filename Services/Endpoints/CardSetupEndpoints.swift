import APIKit

struct GetCardSetupCredentialRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/card-setup"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = CardSetupCredential
}
