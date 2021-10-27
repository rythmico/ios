import APIKit

struct BookingApplicationsGetRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/booking-applications"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = [BookingApplication]
}

struct BookingApplicationsRetractRequest: RythmicoAPIRequest {
    var bookingApplicationId: String

    let method: HTTPMethod = .patch
    var path: String { "/booking-applications/\(bookingApplicationId)/retract" }
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = BookingApplication
}
