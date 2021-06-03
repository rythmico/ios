import Foundation
import PhoneNumberKit

struct Checkout: Decodable, Hashable {
    @E164PhoneNumberOptional
    var phoneNumber: PhoneNumber?
    var pricePerLesson: Price
    var availableCards: [Card]
}
