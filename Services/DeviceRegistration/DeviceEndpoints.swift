import APIKit

struct AddDeviceRequest: RythmicoAPIRequest {
    var token: String

    let method: HTTPMethod = .post
    let path: String = "/devices"
    var headerFields: [String: String] = [:]

    var bodyParameters: BodyParameters? {
        struct Body: Encodable {
            var token: String
        }
        return JSONEncodableBodyParameters(object: Body(token: token))
    }

    typealias Response = Void
}
