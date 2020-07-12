import Foundation
import Sugar

final class BookingRequestFetchingServiceStub: BookingRequestFetchingServiceProtocol {
    var result: SimpleResult<[BookingRequest]>
    var delay: TimeInterval?

    init(result: SimpleResult<[BookingRequest]>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func bookingRequests(accessToken: String, completion: @escaping CompletionHandler) {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(self.result)
            }
        } else {
            completion(result)
        }
    }
}

final class BookingRequestFetchingServiceSpy: BookingRequestFetchingServiceProtocol {
    var requestCount = 0

    func bookingRequests(accessToken: String, completion: @escaping CompletionHandler) {
        requestCount += 1
    }
}

final class BookingRequestFetchingServiceDummy: BookingRequestFetchingServiceProtocol {
    func bookingRequests(accessToken: String, completion: @escaping CompletionHandler) {
        // NO-OP
    }
}
