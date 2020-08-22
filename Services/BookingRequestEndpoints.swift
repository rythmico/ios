import APIKit

struct BookingRequestsGetRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/booking-requests"

    typealias Response = [BookingRequest]
    typealias Error = RythmicoAPIError
}

struct BookingRequestApplyRequest: RythmicoAPIRequest {
    typealias Properties = (bookingRequestId: String, body: Body)

    struct Body: Encodable {
        var privateNote: String
    }

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .post
    var path: String { "/booking-requests/\(self.bookingRequestId)/apply" }

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: self.body)
    }

    typealias Response = BookingApplication
    typealias Error = RythmicoAPIError
}
