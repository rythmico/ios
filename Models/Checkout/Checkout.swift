import Foundation
import PhoneNumberKit

struct Checkout: Equatable, Decodable, Hashable {
    @E164PhoneNumberOptional
    var phoneNumber: PhoneNumber?
    var pricePerLesson: Price
    var availableCards: [Card]
    var stripeClientSecret: String
}
