import APIKit

struct AddDeviceRequest: RythmicoAPIRequest {
    struct Properties {
        struct Body: Encodable {
            var token: String
        }

        let body: Body
    }

    let accessToken: String
    let properties: Properties

    let method: HTTPMethod = .post
    let path: String = "/devices"

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: properties.body)
    }

    typealias Response = Void
    typealias Error = RythmicoAPIError
}
