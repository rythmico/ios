import Foundation
import Sugar

final class PushNotificationAuthorizationManagerStub: PushNotificationAuthorizationManagerProtocol {
    var authorizationStatus: PushNotificationAuthorizationStatus
    var requestAuthorizationResult: SimpleResult<Bool>

    init(
        authorizationStatus: PushNotificationAuthorizationStatus,
        requestAuthorizationResult: SimpleResult<Bool>
    ) {
        self.authorizationStatus = authorizationStatus
        self.requestAuthorizationResult = requestAuthorizationResult
    }

    func getAuthorizationStatus(completion: @escaping GetCompletionHandler) {
        completion(authorizationStatus)
    }

    func requestAuthorization(completion: @escaping RequestCompletionHandler) {
        completion(requestAuthorizationResult)
    }
}

final class PushNotificationAuthorizationManagerDummy: PushNotificationAuthorizationManagerProtocol {
    func getAuthorizationStatus(completion: @escaping GetCompletionHandler) {
        // NO-OP
    }

    func requestAuthorization(completion: @escaping RequestCompletionHandler) {
        // NO-OP
    }
}
