import APIKit

struct BookingApplicationsGetRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/booking-applications"

    typealias Response = [BookingApplication]
    typealias Error = RythmicoAPIError
}
