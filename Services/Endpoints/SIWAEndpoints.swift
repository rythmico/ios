import APIKit
import CoreDTO

struct SIWARequest: RythmicoAPIRequest {
    var body: SIWABody

    let method: HTTPMethod = .post
    var path: String { "/auth/siwa" }
    var headerFields: [String: String] = [:]

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: body)
    }

    typealias Response = SIWAResponse
}
