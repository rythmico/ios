import FoundationEncore

struct Price: Equatable, Decodable, Hashable {
    enum Currency: String, Equatable, Decodable, Hashable {
        // Supported currencies
        case GBP
    }

    var amount: PreciseDecimal
    var currency: Currency
}

extension NumberFormatter {
    func string(from price: Price) -> String {
        currencyCode = price.currency.rawValue
        return string(from: price.amount.value)
    }
}
