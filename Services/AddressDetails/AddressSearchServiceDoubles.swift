import Foundation
import Sugar

final class AddressSearchServiceStub: AddressSearchServiceProtocol {
    var result: SimpleResult<[AddressDetails]>
    var delay: TimeInterval?

    init(result: SimpleResult<[AddressDetails]>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func addresses(accessToken: String, postcode: String, completion: @escaping CompletionHandler) {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(self.result)
            }
        } else {
            completion(result)
        }
    }
}

final class AddressSearchServiceSpy: AddressSearchServiceProtocol {
    var result: SimpleResult<[AddressDetails]>

    private(set) var latestPostcode: String?
    private(set) var searchCount = 0

    init(result: SimpleResult<[AddressDetails]>) {
        self.result = result
    }

    func addresses(accessToken: String, postcode: String, completion: @escaping CompletionHandler) {
        latestPostcode = postcode
        searchCount += 1
        completion(result)
    }
}

final class AddressSearchServiceDummy: AddressSearchServiceProtocol {
    func addresses(accessToken: String, postcode: String, completion: @escaping CompletionHandler) {}
}
