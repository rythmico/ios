import APIKit
import CoreDTO
import FoundationEncore

struct AddressSearchRequest: RythmicoAPIRequest {
    struct BlankPostcodeError: LocalizedError {
        let errorDescription: String? = "Postcode must not be empty"
    }

    var postcode: String

    init(postcode: String) throws {
        let postcode = try postcode
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: String.whitespace, with: String.empty)
            .lowercased()
            .nilIfBlank ?! BlankPostcodeError()

        self.postcode = postcode
    }

    let method: HTTPMethod = .get
    var path: String { "/address-lookup/" + postcode }
    var headerFields: [String: String] = [:]

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        urlRequest => (\.cachePolicy, .returnCacheDataElseLoad)
    }

    typealias Response = AddressLookupResponse
}
