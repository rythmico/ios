import APIKit
import CoreDTO

struct RegisterAPNSTokenRequest: RythmicoAPIRequest {
    var deviceToken: String

    let method: HTTPMethod = .post
    let path: String = "/apns-tokens"
    var headerFields: [String: String] = [:]

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: RegisterAPNSTokenBody(deviceToken: deviceToken))
    }

    typealias Response = Void
}
