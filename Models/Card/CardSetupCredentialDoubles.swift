import FoundationSugar

extension CardSetupCredential {
    static let stub = Self(
        stripeClientSecret: UUID().uuidString
    )
}
