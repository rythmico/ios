import APIKit

struct GetBookingRequestsRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/booking-requests"

    typealias Response = [BookingRequest]
    typealias Error = RythmicoAPIError
}

struct CreateBookingApplicationRequest: RythmicoAPIRequest {
    typealias Properties = (id: String, body: Body)

    struct Body: Encodable {
        var privateNote: String
    }

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .post
    var path: String { "/booking-request/\(self.id)/apply" }

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: self.body)
    }

    typealias Response = Void
    typealias Error = RythmicoAPIError
}
