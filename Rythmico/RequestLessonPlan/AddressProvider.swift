import Foundation
import Sugar

protocol AddressProviderProtocol: AnyObject {
    typealias CompletionHandler = SimpleResultHandler<[Address]>
    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler)
}
