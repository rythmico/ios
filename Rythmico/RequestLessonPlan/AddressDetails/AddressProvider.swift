import APIKit
import Sugar

protocol AddressProviderProtocol: AnyObject {
    typealias CompletionHandler = SimpleResultHandler<[AddressDetails]>
    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler)
}

final class AddressSearchService: AddressProviderProtocol {
    private let accessTokenProvider: AuthenticationAccessTokenProvider
    private let sessionConfiguration = URLSessionConfiguration.ephemeral

    init(accessTokenProvider: AuthenticationAccessTokenProvider) {
        self.accessTokenProvider = accessTokenProvider
    }

    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler) {
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                do {
                    let session = Session(adapter: URLSessionAdapter(configuration: self.sessionConfiguration))
                    let request = try AddressSearchRequest(accessToken: accessToken, postcode: postcode)
                    session.send(request, callbackQueue: .main) { result in
                        completion(result.map([AddressDetails].init).mapError { $0 as Error })
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension Array where Element == AddressDetails {
    init(_ response: AddressSearchRequest.Response) {
        self = response.addresses.map {
            AddressDetails(
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

private struct AddressSearchRequest: RythmicoAPIRequest {
    let accessToken: String
    let postcode: String

    init(accessToken: String, postcode: String) throws {
        let sanitizedPostcode = postcode
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: String.whitespace, with: String.empty)
            .lowercased()

        guard !sanitizedPostcode.isEmpty else {
            throw Error(message: "Postcode must not be empty")
        }

        self.accessToken = accessToken
        self.postcode = sanitizedPostcode
    }

    let method: HTTPMethod = .get
    var path: String { "/address-lookup/" + postcode }

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
