import FoundationEncore

extension Price {
    static let nonDecimalStub = Self(amount: 45, currency: .GBP)
    static let exactDecimalStub = Self(amount: 47.50, currency: .GBP)
    static let inexactDecimalStub = Self(amount: 47.25, currency: .GBP)
}
