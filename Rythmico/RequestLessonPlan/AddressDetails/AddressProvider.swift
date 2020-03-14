import APIKit
import Sugar

protocol AddressProviderProtocol: AnyObject {
    typealias CompletionHandler = SimpleResultHandler<[Address]>
    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler)
}

final class AddressSearchService: AddressProviderProtocol {
    private let sessionConfiguration = URLSessionConfiguration.ephemeral

    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler) {
        do {
            let session = Session(adapter: URLSessionAdapter(configuration: sessionConfiguration))
            let request = try AddressSearchRequest(postcode: postcode)
            session.send(request, callbackQueue: .main) { result in
                completion(result.map([Address].init).mapError { $0 as Error })
            }
        } catch {
            completion(.failure(error))
        }
    }
}

private extension Array where Element == Address {
    init(_ response: AddressSearchRequest.Response) {
        self = response.addresses.map {
            Address(
                latitude: response.latitude,
                longitude: response.longitude,
                line1: $0.line1, line2: $0.line2,
                line3: $0.line3, line4: $0.line4,
                city: $0.city,
                postcode: response.postcode,
                country: $0.country
            )
        }
    }
}

private struct AddressSearchRequest: DecodableJSONRequest {
    let postcode: String

    init(postcode: String) throws {
        let sanitizedPostcode = postcode
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: String.whitespace, with: String.empty)
            .lowercased()

        guard !sanitizedPostcode.isEmpty else {
            throw Error(message: "Postcode must not be empty")
        }

        self.postcode = sanitizedPostcode
    }

    let host = "api.getAddress.io"
    let method: HTTPMethod = .get
    var path: String { "/find/" + postcode }
    let parameters: Any? = [
        "api-key": Secret.addressSearchServiceAPIToken,
        "expand": "true",
        "sort": "true",
    ]

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        return urlRequest
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

    struct Error: LocalizedError, Decodable {
        var message: String
        var errorDescription: String? { message }

        private enum CodingKeys: String, CodingKey {
            case message = "Message"
        }
    }
}
