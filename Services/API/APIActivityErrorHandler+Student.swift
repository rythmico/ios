import FoundationEncore

final class APIActivityErrorHandler: APIActivityErrorHandlerProtocol {
    private let appStatusProvider: AppStatusProvider
    private let userCredentialProvider: UserCredentialProviderBase

    init(
        appStatusProvider: AppStatusProvider,
        userCredentialProvider: UserCredentialProviderBase
    ) {
        self.appStatusProvider = appStatusProvider
        self.userCredentialProvider = userCredentialProvider
    }

    func handle(_ error: RythmicoAPIError, complete: Action) {
        switch error.reason {
        case .unknown, .none:
            complete()
        case .known(.clientOutdated):
            appStatusProvider.isAppOutdated = true
        case .known(.unauthorized):
            userCredentialProvider.userCredential = nil
        }
    }
}
