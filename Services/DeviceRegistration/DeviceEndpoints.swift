import APIKit

struct AddDeviceRequest: RythmicoAPIRequestNoResponse {
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
}
