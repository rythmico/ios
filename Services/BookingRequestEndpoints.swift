import APIKit

struct GetBookingRequestsRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/booking-requests"

    typealias Response = [BookingRequest]
    typealias Error = RythmicoAPIError
}
