import APIKit

struct BookingsGetRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/bookings"

    typealias Response = [Booking]
    typealias Error = RythmicoAPIError
}
