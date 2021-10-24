import FoundationEncore

final class SIWAAuthorizationControllerSpy: SIWAAuthorizationControllerProtocol {
    static var didInit: Handler<SIWAAuthorizationControllerSpy>?

    let authorizationRequests: [Request]
    var didSetDelegate: Handler<Delegate>?
    var didPerformRequests: Action?

    init(authorizationRequests: [Request]) {
        self.authorizationRequests = authorizationRequests
        Self.didInit?(self)
    }

    var delegate: Delegate? {
        didSet {
            guard let delegate = delegate else {
                return
            }
            didSetDelegate?(delegate)
        }
    }

    func performRequests() {
        didPerformRequests?()
    }

    deinit {
        Self.didInit = nil
    }
}
