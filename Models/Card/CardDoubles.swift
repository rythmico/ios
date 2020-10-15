import Foundation

extension Card {
    static let mastercardStub = Self(
        id: UUID().uuidString,
        brand: .masterCard,
        lastFourDigits: "4242",
        expiryMonth: 12,
        expiryYear: 32
    )

    static let visaStub = Self(
        id: UUID().uuidString,
        brand: .visa,
        lastFourDigits: "4242",
        expiryMonth: 8,
        expiryYear: 23
    )
}
