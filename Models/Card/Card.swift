import Foundation
import Stripe

struct Card: Equatable, Decodable, Identifiable, Hashable {
    typealias Brand = STPCardBrand

    var id: String
    var brand: Brand
    var lastFourDigits: String
    var expiryMonth: Int
    var expiryYear: Int
}

protocol STPSetupIntentProtocol {
    var paymentMethodID: String? { get }
}

extension STPSetupIntent: STPSetupIntentProtocol {}

extension Card {
    init?(setupIntent: STPSetupIntentProtocol, cardDetails: STPPaymentMethodCardParams) {
        guard
            let paymentMethodId = setupIntent.paymentMethodID,
            let number = cardDetails.number,
            let lastFourDigits = cardDetails.last4,
            let expiryMonth = cardDetails.expMonth,
            let expiryYear = cardDetails.expYear
        else {
            return nil
        }
        self.init(
            id: paymentMethodId,
            brand: STPCardValidator.brand(forNumber: number),
            lastFourDigits: lastFourDigits,
            expiryMonth: expiryMonth.intValue,
            expiryYear: expiryYear.intValue
        )
    }
}

extension Card.Brand: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(try container.decode(String.self))
    }

    init(_ rawBrandString: String) {
        self = STPPaymentMethodCard.brand(from: rawBrandString)
    }

    var name: String {
        STPStringFromCardBrand(self)
    }

    var logo: UIImage {
        STPImageLibrary.brandImage(for: self)
    }
}
