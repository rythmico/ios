import Foundation
import class AuthenticationServices.ASAuthorizationAppleIDProvider
import Sugar

protocol AppleAuthorizationCredentialRevocationNotifying: AnyObject {
    var revocationHandler: Action? { get set }
}

final class AppleAuthorizationCredentialRevocationNotifier: AppleAuthorizationCredentialRevocationNotifying {
    private let notificationCenter: NotificationCenterProtocol
    private var token: NSObjectProtocol?

    var revocationHandler: Action? {
        didSet {
            handlerDidChange()
        }
    }

    init(notificationCenter: NotificationCenterProtocol) {
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
