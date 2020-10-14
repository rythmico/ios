import Foundation

extension Checkout {
    static let stub = Self(
        phoneNumber: .stub,
        pricePerLesson: .nonDecimalStub,
        availableCards: [.stub]
    )
}

extension Checkout.Card {
    static let stub = Self(
        id: "ID123",
        brand: .visa,
        lastFourDigits: "4242",
        expiryMonth: 8,
        expiryYear: 23,
        cvc: "123"
    )
}
