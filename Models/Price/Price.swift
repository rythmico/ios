import Foundation

struct Price: Equatable, Decodable, Hashable {
    enum Currency: String, Equatable, Decodable, Hashable {
        // Supported currencies
        case GBP
    }

    var amount: Decimal
    var currency: Currency
}
