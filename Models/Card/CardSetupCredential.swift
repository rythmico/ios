import Foundation

struct CardSetupCredential: Decodable, Equatable, Hashable {
    var stripeClientSecret: String
}
