import Foundation
import class AuthenticationServices.ASAuthorizationAppleIDProvider
import Sugar

public protocol AppleAuthorizationCredentialRevocationObserving: AnyObject {
    var revocationHandler: Action? { get set }
}

public final class AppleAuthorizationCredentialRevocationObserver: AppleAuthorizationCredentialRevocationObserving {
    private let notificationCenter: NotificationCenterProtocol
    private var token: NSObjectProtocol?

    public var revocationHandler: Action? {
        didSet {
            handlerDidChange()
        }
    }

    public init(notificationCenter: NotificationCenterProtocol) {
        self.notificationCenter = notificationCenter
    }

    private func handlerDidChange() {
        token = notificationCenter.addObserver(
            forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.revocationHandler?()
        }
    }
}
