import FoundationEncore
import PhoneNumberKit

struct Checkout: Decodable, Hashable {
    struct Policies: Decodable, Hashable {
        var skipFreeBeforePeriod: PeriodDuration
        var pauseFreeBeforePeriod: PeriodDuration
        var cancelFreeBeforePeriod: PeriodDuration
    }

    @E164PhoneNumberOptional
    var phoneNumber: PhoneNumber?
    var pricePerLesson: Price
    var availableCards: [Card]
    var policies: Policies
}
