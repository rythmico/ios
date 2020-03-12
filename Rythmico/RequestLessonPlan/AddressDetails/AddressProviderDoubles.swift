import Foundation
import Sugar

final class AddressProviderStub: AddressProviderProtocol {
    var result: SimpleResult<[Address]>

    init(result: SimpleResult<[Address]>) {
        self.result = result
    }

    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler) {
        completion(result)
    }
}
