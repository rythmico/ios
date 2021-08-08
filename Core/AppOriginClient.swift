import FoundationSugar

struct AppOriginClient {
    var get: () -> App.Origin

    func callAsFunction() -> App.Origin { get() }
}

extension AppOriginClient {
    static let live = Self(
        get: {
            guard let receiptURL = Bundle.main.appStoreReceiptURL else {
                return .appStore
            }
            return receiptURL.absoluteString.contains("sandboxReceipt") ? .testFlight : .appStore
        }
    )
}
