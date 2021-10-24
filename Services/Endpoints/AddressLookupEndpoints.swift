import FoundationEncore
import APIKit

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
}

extension AddressSearchRequest {
    struct Response: Decodable {
        struct Address: Decodable {
            var line1, line2, line3, line4: String
            var city: String
            var country: String

            private enum CodingKeys: String, CodingKey {
                case line1 = "line_1", line2 = "line_2"
                case line3 = "line_3", line4 = "line_4"
                case city = "town_or_city"
                case country
            }
        }

        var postcode: String
        var latitude: Double
        var longitude: Double
        var addresses: [Address]
    }
}

extension AddressSearchRequest.Response {
    static var stub: Self {
        .init(
            postcode: "TA3 0XS",
            latitude: 0,
            longitude: 0,
            addresses: [.stub]
        )
    }
}

extension AddressSearchRequest.Response.Address {
    static var stub: Self {
        .init(
            line1: "Apartment 30",
            line2: "85 Shore Street",
            line3: "",
            line4: "",
            city: "Stoke St Mary",
            country: "England"
        )
    }
}
