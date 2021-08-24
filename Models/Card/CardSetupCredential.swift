import FoundationEncore

struct CardSetupCredential: Decodable, Equatable, Hashable {
    var stripeClientSecret: String
}
