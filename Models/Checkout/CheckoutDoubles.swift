import FoundationSugar

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
        skipFreeBeforePeriod: .init(.init(hour: 24)),
        pauseFreeBeforePeriod: .init(.init(hour: 24)),
        cancelFreeBeforePeriod: .init(.init(hour: 24))
    )
}
