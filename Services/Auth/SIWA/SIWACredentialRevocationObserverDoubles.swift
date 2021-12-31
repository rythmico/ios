import FoundationEncore

final class SIWACredentialRevocationNotifierFake: SIWACredentialRevocationNotifying {
    var revocationHandler: Action?
}

final class SIWACredentialRevocationNotifierDummy: SIWACredentialRevocationNotifying {
    var revocationHandler: Action?
}
