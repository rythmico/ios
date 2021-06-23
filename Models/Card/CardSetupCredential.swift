import FoundationSugar

struct CardSetupCredential: Decodable, Equatable, Hashable {
    var stripeClientSecret: String
}
