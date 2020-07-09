import APIKit
import Sugar

protocol BookingRequestFetchingServiceProtocol {
    typealias CompletionHandler = SimpleResultHandler<[BookingRequest]>
    func bookingRequests(accessToken: String, completion: @escaping CompletionHandler)
}

final class BookingRequestFetchingService: BookingRequestFetchingServiceProtocol {
    func bookingRequests(accessToken: String, completion: @escaping CompletionHandler) {
        let session = Session(adapter: URLSessionAdapter(configuration: .ephemeral))
        let request = GetBookingRequestsRequest(accessToken: accessToken)
        session.send(request)
    }
}

private struct GetBookingRequestsRequest: RythmicoAPIRequest {
    let accessToken: String

    let method: HTTPMethod = .get
    let path: String = "/booking-requests"
}

extension GetBookingRequestsRequest {
    typealias Response = [BookingRequest]
    typealias Error = RythmicoAPIError
}
