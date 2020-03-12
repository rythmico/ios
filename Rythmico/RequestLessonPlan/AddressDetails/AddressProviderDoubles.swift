import Foundation
import Sugar

final class AddressProviderStub: AddressProviderProtocol {
    var result: SimpleResult<[Address]>
    var delay: TimeInterval?

    init(result: SimpleResult<[Address]>, delay: TimeInterval? = nil) {
        self.result = result
        self.delay = delay
    }

    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler) {
        if let delay = delay {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion(self.result)
            }
        } else {
            completion(result)
        }
    }
}
