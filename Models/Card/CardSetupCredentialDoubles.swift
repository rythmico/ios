import Foundation

extension CardSetupCredential {
    static let stub = Self(
        stripeClientSecret: UUID().uuidString
    )
}
