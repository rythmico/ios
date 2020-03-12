import Foundation
import Sugar

protocol AddressProviderProtocol: AnyObject {
    typealias CompletionHandler = SimpleResultHandler<[Address]>
    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler)
}

final class AddressSearchService: AddressProviderProtocol {
    private let urlSessionConfiguration = URLSessionConfiguration.ephemeral.then {
        $0.requestCachePolicy = .returnCacheDataElseLoad
    }

    func addresses(withPostcode postcode: String, completion: @escaping CompletionHandler) {
        let sanitizedPostcode = postcode
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: String.whitespace, with: String.empty)
            .lowercased()

        guard !sanitizedPostcode.isEmpty else {
            let errorDescription = "Postcode must not be empty"
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
            completion(.failure(error))
            return
        }

        let urlSession = URLSession(configuration: urlSessionConfiguration)
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.getAddress.io"
        urlComponents.path = "/find/" + sanitizedPostcode
        urlComponents.queryItems = [
            URLQueryItem(name: "api-key", value: Secret.addressSearchServiceAPIToken),
            URLQueryItem(name: "expand", value: "true"),
            URLQueryItem(name: "sort", value: "true"),
        ]
        guard let url = urlComponents.url else {
            preconditionFailure("Address search URL could not be constructed")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                preconditionFailure("If error is nil, data and response objects must exist")
            }
            guard !(400..<600).contains(response.statusCode) else {
                let errorDescription = HTTPURLResponse.localizedString(forStatusCode: response.statusCode).localizedCapitalized
                let error = NSError(domain: NSURLErrorDomain, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                completion(.failure(error))
                return
            }
            let addresses = Result {
                try JSONDecoder().decode(Response.self, from: data)
            }
            .map { response in
                response.addresses.map {
                    Address(
                        latitude: response.latitude,
                        longitude: response.longitude,
                        line1: $0.line1,
                        line2: $0.line2,
                        line3: $0.line3,
                        line4: $0.line4,
                        city: $0.city,
                        postcode: response.postcode,
                        country: $0.country
                    )
                }
            }
            completion(addresses)
        }.resume()
    }
}

extension AddressSearchService {
    private struct Response: Decodable {
        struct Address: Decodable {
            var line1: String
            var line2: String
            var line3: String
            var line4: String
            var city: String
            var country: String

            private enum CodingKeys: String, CodingKey {
                case line1 = "line_1"
                case line2 = "line_2"
                case line3 = "line_3"
                case line4 = "line_4"
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
