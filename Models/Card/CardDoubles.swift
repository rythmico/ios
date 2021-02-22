import Foundation

extension Card.ID {
    static func random() -> Self {
        Self(rawValue: UUID().uuidString)
    }
}

extension Card {
    static let mastercardStub = Self(
        id: .random(),
        brand: .mastercard,
        lastFourDigits: "4242",
        expiryMonth: 12,
        expiryYear: 32
    )

    static let visaStub = Self(
        id: .random(),
        brand: .visa,
        lastFourDigits: "4242",
        expiryMonth: 8,
        expiryYear: 23
    )
}
