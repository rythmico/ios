import Sugar

public final class AppleAuthorizationCredentialRevocationObserverFake: AppleAuthorizationCredentialRevocationObserving {
    public var revocationHandler: Action?

    public init() {}
}
