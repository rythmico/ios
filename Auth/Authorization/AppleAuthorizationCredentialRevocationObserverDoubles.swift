import Sugar

final class AppleAuthorizationCredentialRevocationObserverFake: AppleAuthorizationCredentialRevocationObserving {
    var revocationHandler: Action?
}
