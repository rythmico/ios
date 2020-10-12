import Foundation

struct Price {
    enum Currency: String, Equatable, Decodable, Hashable {
        // Supported currencies
        case GBP
    }

    var amount: Decimal
    var currency: Currency
}
