import APIKit
import CoreDTO

struct SIWARequest: APIRequest {
    let method: HTTPMethod = .post
    let path: String = "/auth/siwa"
    let authRequired: Bool = false
    var headerFields: [String: String] = [:]
    let body: SIWABody

    typealias Response = SIWAResponse
}
