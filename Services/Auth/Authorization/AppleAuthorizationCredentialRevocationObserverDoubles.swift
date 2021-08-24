import FoundationEncore

final class AppleAuthorizationCredentialRevocationNotifierFake: AppleAuthorizationCredentialRevocationNotifying {
    var revocationHandler: Action?
}

final class AppleAuthorizationCredentialRevocationNotifierDummy: AppleAuthorizationCredentialRevocationNotifying {
    var revocationHandler: Action?
}
