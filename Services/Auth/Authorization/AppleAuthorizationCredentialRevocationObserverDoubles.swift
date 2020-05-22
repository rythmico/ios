import Sugar

final class AppleAuthorizationCredentialRevocationNotifierFake: AppleAuthorizationCredentialRevocationNotifying {
    var revocationHandler: Action?
}
