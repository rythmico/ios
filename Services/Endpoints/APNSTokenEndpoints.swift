import APIKit
import CoreDTO

struct RegisterAPNSTokenRequest: APIRequest {
    let method: HTTPMethod = .post
    let path: String = "/apns-tokens"
    var headerFields: [String: String] = [:]
    var body: RegisterAPNSTokenBody

    typealias Response = Void
}
