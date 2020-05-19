import Foundation
import FirebaseInstanceID
import APIKit

protocol PushNotificationRegistrationServiceProtocol {
    func registerForPushNotifications()
}

protocol PushNotificationUnregistrationServiceProtocol {
    func unregisterForPushNotifications()
}

final class PushNotificationRegistrationService: PushNotificationRegistrationServiceProtocol {
    private let manager: InstanceID
    private let accessTokenProvider: AuthenticationAccessTokenProvider

    init(
        manager: InstanceID,
        accessTokenProvider: AuthenticationAccessTokenProvider
    ) {
        self.manager = manager
        self.accessTokenProvider = accessTokenProvider
    }

    func registerForPushNotifications() {
        accessTokenProvider.getAccessToken { result in
            switch result {
            case .success(let accessToken):
                let session = Session(adapter: URLSessionAdapter(configuration: .ephemeral))
                self.manager.instanceID { result, _ in
                    guard let token = result?.token else {
                        return
                    }
                    let request = AddDeviceRequest(accessToken: accessToken, body: .init(token: token))
                    session.send(request)
                }
            case .failure:
                break
            }
        }
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

final class PushNotificationUnregistrationService: PushNotificationUnregistrationServiceProtocol {
    private let manager: InstanceID

    init(manager: InstanceID) {
        self.manager = manager
    }

    func unregisterForPushNotifications() {
        manager.deleteID { _ in }
    }
}
