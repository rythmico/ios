import Foundation
import PhoneNumberKit
import ISO8601PeriodDuration

struct Checkout: Decodable, Hashable {
    struct Policies: Decodable, Hashable {
        @ISO8601PeriodDuration var skipFreeBeforePeriod: DateComponents
        @ISO8601PeriodDuration var pauseFreeBeforePeriod: DateComponents
        @ISO8601PeriodDuration var cancelFreeBeforePeriod: DateComponents
    }

    @E164PhoneNumberOptional
    var phoneNumber: PhoneNumber?
    var pricePerLesson: Price
    var availableCards: [Card]
    var policies: Policies
}
