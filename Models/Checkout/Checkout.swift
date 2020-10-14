import Foundation
import PhoneNumberKit
import Stripe

struct Checkout: Equatable, Decodable, Hashable {
    struct Card: Equatable, Decodable, Identifiable, Hashable {
        typealias Brand = STPCardBrand

        var id: String
        var brand: Brand
        var lastFourDigits: String
        var expiryMonth: Int
        var expiryYear: Int
    }

    @E164PhoneNumberOptional
    var phoneNumber: PhoneNumber?
    var pricePerLesson: Price
    var availableCards: [Card]
    var stripeClientSecret: String
}

protocol STPSetupIntentProtocol {
    var paymentMethodID: String? { get }
}

extension STPSetupIntent: STPSetupIntentProtocol {}

extension Checkout.Card {
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

extension STPCardBrand: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(try container.decode(String.self))
    }

    init(_ rawBrandString: String) {
        switch rawBrandString.lowercased() {
        case "visa": self = .visa
        case "amex": self = .amex
        case "mastercard": self = .masterCard
        case "discover": self = .discover
        case "jcb": self = .JCB
        case "diners": self = .dinersClub
        case "unionpay": self = .unionPay
        default: self = .unknown
        }
    }

    var name: String {
        STPStringFromCardBrand(self)
    }

    var logo: UIImage {
        STPImageLibrary.brandImage(for: self)
    }
}
