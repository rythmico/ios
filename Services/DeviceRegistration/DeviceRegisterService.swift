import Foundation
import APIKit

protocol DeviceRegisterServiceProtocol {
    func registerDevice(accessToken: String, deviceToken: String)
}

final class DeviceRegisterService: DeviceRegisterServiceProtocol {
    func registerDevice(accessToken: String, deviceToken: String) {
        let session = Session(adapter: URLSessionAdapter(configuration: .ephemeral))
        let request = AddDeviceRequest(accessToken: accessToken, body: .init(token: deviceToken))
        session.send(request)
    }
}

private struct AddDeviceRequest: RythmicoAPIRequestNoResponse {
    struct Body: Encodable {
        var token: String
    }

    let accessToken: String
    let body: Body

    let method: HTTPMethod = .post
    let path: String = "/devices"

    var bodyParameters: BodyParameters? {
        JSONEncodableBodyParameters(object: body)
    }
}
