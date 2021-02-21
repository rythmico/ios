import UIKit
import Stripe
import Tagged

struct Card: Equatable, Decodable, Identifiable, Hashable {
    typealias ID = Tagged<Self, String>
    typealias Brand = STPCardBrand

    var id: ID
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
            id: ID(rawValue: paymentMethodId),
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
        self = STPCardBrandUtilities.brand(from: rawBrandString)
    }

    var name: String {
        STPCardBrandUtilities.name(from: self)
    }

    var logo: UIImage {
        STPImageLibrary.cardBrandImage(for: self)
    }
}

private extension STPCardBrandUtilities {
    // Mirrors STPPaymentMethodCard.brand(from:) internal function.
    class func brand(from string: String) -> STPCardBrand {
        guard let object = STPPaymentMethodCard.decodedObject(fromAPIResponse: ["brand": string]) else {
            assertionFailure("Invalid internal parsing of raw brand name \(string)")
            return .unknown
        }
        return object.brand
    }

    // Corrects silly optional return value of STPCardBrandUtilities.stringFrom(_:) public function.
    class func name(from brand: STPCardBrand) -> String {
        guard let name = STPCardBrandUtilities.stringFrom(brand) else {
            assertionFailure("Invalid internal parsing of brand enum case \(brand)")
            return .empty
        }
        return name
    }
}
