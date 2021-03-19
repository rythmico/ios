import Foundation
import FoundationSugar

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
        return string(for: price.amount) !! preconditionFailure("Price formatter failed to format Price: \(price)")
    }
}
