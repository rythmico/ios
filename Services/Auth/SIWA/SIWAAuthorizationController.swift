import AuthenticationServices

typealias SIWAAuthorizationController = ASAuthorizationController

protocol SIWAAuthorizationControllerProtocol: AnyObject {
    typealias Request = ASAuthorizationRequest
    typealias Delegate = ASAuthorizationControllerDelegate

    init(authorizationRequests: [Request])

    var authorizationRequests: [Request] { get }
    var delegate: Delegate? { get set }

    func performRequests()
}

extension SIWAAuthorizationController: SIWAAuthorizationControllerProtocol {}
