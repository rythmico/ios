import Foundation

extension Checkout {
    static let stub = Self(
        phoneNumber: .stub,
        pricePerLesson: .nonDecimalStub,
        availableCards: [.mastercardStub]
    )
}

extension Checkout.Card {
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
