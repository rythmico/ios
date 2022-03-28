import FoundationEncore

struct Checkout: Decodable, Hashable {
    struct Policies: Decodable, Hashable {
        var skipFreeBeforePeriod: PeriodDuration
        var pauseFreeBeforePeriod: PeriodDuration
        var cancelFreeBeforePeriod: PeriodDuration
    }

    var phoneNumber: PhoneNumber?
    var pricePerLesson: Price
    var availableCards: [Card]
    var policies: Policies
}
