import APIKit

struct BookingsGetRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/bookings"
    var headerFields: [String: String] = [:]

    typealias Response = [Booking]
}
