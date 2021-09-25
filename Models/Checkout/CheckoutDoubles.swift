import FoundationEncore

extension Checkout {
    static let stub = Self(
        phoneNumber: .stub,
        pricePerLesson: .nonDecimalStub,
        availableCards: [.mastercardStub],
        policies: .stub
    )
}

extension Checkout.Policies {
    static let stub = Self(
        skipFreeBeforePeriod: .init(hours: 24),
        pauseFreeBeforePeriod: .init(hours: 24),
        cancelFreeBeforePeriod: .init(hours: 24)
    )
}
