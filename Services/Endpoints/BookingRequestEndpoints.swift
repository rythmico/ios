import APIKit

struct BookingRequestsGetRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/booking-requests"
    var headerFields: [String: String] = [:]

    typealias Response = [BookingRequest]
}

struct BookingRequestApplyRequest: RythmicoAPIRequest {
    var bookingRequestID: String
    var privateNote: String

    let method: HTTPMethod = .post
    var path: String { "/booking-requests/\(bookingRequestID)/apply" }
    var headerFields: [String: String] = [:]

    var bodyParameters: BodyParameters? {
        struct Body: Encodable {
            var privateNote: String
        }
        return JSONEncodableBodyParameters(object: Body(privateNote: privateNote))
    }

    typealias Response = BookingApplication
}
