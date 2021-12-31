import FoundationEncore

final class APIActivityErrorHandler: APIActivityErrorHandlerProtocol {
    private let appStatusProvider: AppStatusProvider
    private let userCredentialProvider: UserCredentialProviderBase
    private let settings: UserDefaults

    init(
        appStatusProvider: AppStatusProvider,
        userCredentialProvider: UserCredentialProviderBase,
        settings: UserDefaults
    ) {
        self.appStatusProvider = appStatusProvider
        self.userCredentialProvider = userCredentialProvider
        self.settings = settings
    }

    func handle(_ error: RythmicoAPIError, complete: Action) {
        switch error.reason {
        case .unknown, .none:
            complete()
        case .known(.clientOutdated):
            appStatusProvider.isAppOutdated = true
        case .known(.unauthorized):
            userCredentialProvider.userCredential = nil
            settings.tutorVerified = false
        case .known(.tutorProfileNotCreated):
            settings.tutorVerified = false
        }
    }
}
