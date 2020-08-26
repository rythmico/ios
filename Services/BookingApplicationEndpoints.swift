import APIKit

struct BookingApplicationsGetRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/booking-applications"

    typealias Response = [BookingApplication]
    typealias Error = RythmicoAPIError
}

struct BookingApplicationsRetractRequest: RythmicoAPIRequest {
    struct Properties {
        var bookingApplicationId: String
    }

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .patch
    var path: String { "/booking-applications/\(self.bookingApplicationId)/retract" }

    typealias Response = BookingApplication
    typealias Error = RythmicoAPIError
}
