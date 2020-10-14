import Foundation

struct Price: Equatable, Decodable, Hashable {
    enum Currency: String, Equatable, Decodable, Hashable {
        // Supported currencies
        case GBP
    }

    var amount: Decimal
    var currency: Currency
}

extension NumberFormatter {
    func string(for price: Price) -> String {
        currencyCode = price.currency.rawValue
        usesSignificantDigits = price.amount.isInteger
        guard let formattedPrice = string(for: price.amount) else {
            preconditionFailure("Price formatter failed to format Price: \(price)")
        }
        return formattedPrice
    }
}
