import Foundation
import Sugar

final class PushNotificationAuthorizationManagerStub: PushNotificationAuthorizationManagerBase {
    var requestAuthorizationResult: SimpleResult<Bool>

    init(
        status: PushNotificationAuthorizationStatus,
        requestAuthorizationResult: SimpleResult<Bool>
    ) {
        self.requestAuthorizationResult = requestAuthorizationResult
        super.init()
        self.status = status
    }

    override func refreshAuthorizationStatus() {
        // NO-OP
    }

    override func requestAuthorization(errorHandler: @escaping Handler<Error>) {
        switch requestAuthorizationResult {
        case .success(let granted):
            self.status = granted ? .authorized : .denied
        case .failure(let error):
            errorHandler(error)
        }
    }
}

final class PushNotificationAuthorizationManagerDummy: PushNotificationAuthorizationManagerBase {
    init(_ noop: Void = ()) {}
}
