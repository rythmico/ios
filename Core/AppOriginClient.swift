import FoundationSugar

struct AppOriginClient {
    var isTestFlightApp: () -> Bool
}

extension AppOriginClient {
    static let live = Self(
        isTestFlightApp: {
            guard let receiptURL = Bundle.main.appStoreReceiptURL else {
                return false
            }
            return receiptURL.absoluteString.contains("sandboxReceipt")
        }
    )
}
