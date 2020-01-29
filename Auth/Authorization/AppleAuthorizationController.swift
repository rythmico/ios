import AuthenticationServices

public typealias AppleAuthorizationController = ASAuthorizationController

public protocol AppleAuthorizationControllerProtocol: AnyObject {
    typealias Request = ASAuthorizationRequest
    typealias Delegate = ASAuthorizationControllerDelegate

    init(authorizationRequests: [Request])

    var authorizationRequests: [Request] { get }
    var delegate: Delegate? { get set }

    func performRequests()
}

extension AppleAuthorizationController: AppleAuthorizationControllerProtocol {}
