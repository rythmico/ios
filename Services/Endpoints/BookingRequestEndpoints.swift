import APIKit

struct BookingRequestsGetRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/booking-requests"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = [BookingRequest]
}

struct BookingRequestApplyRequest: RythmicoAPIRequest {
    var bookingRequestID: String
    var privateNote: String

    let method: HTTPMethod = .post
    var path: String { "/booking-requests/\(bookingRequestID)/apply" }
    var headerFields: [String: String] = [:]
    var body: some Encodable {
        struct Body: Encodable {
            var privateNote: String
        }
        return Body(privateNote: privateNote)
    }

    typealias Response = BookingApplication
}
