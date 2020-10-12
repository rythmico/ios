import Foundation

extension Checkout {
    static let stub = Self.init(
        phoneNumber: E164PhoneNumberOptional(wrappedValue: .stub),
        pricePerLesson: .stub,
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
