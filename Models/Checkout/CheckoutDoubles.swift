import Foundation

extension Checkout {
    static let stub = Self(
        phoneNumber: .stub,
        pricePerLesson: .nonDecimalStub,
        availableCards: [.mastercardStub],
        stripeClientSecret: UUID().uuidString
    )
}
