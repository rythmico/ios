import Foundation
import FoundationSugar
import FirebaseCrashlytics
import Combine

protocol ErrorLoggerProtocol {
    func log(_ error: Error)
}

final class ErrorLogger: ErrorLoggerProtocol {
    private let crashlyticsLogger: Crashlytics
    private let userCredentialProvider: UserCredentialProviderBase
    private var cancellable: AnyCancellable?

    init(
        crashlyticsLogger: Crashlytics,
        userCredentialProvider: UserCredentialProviderBase
    ) {
        self.crashlyticsLogger = crashlyticsLogger
        self.userCredentialProvider = userCredentialProvider
        self.cancellable = userCredentialProvider.$userCredential.compactMap { $0?.userId }.sink(receiveValue: crashlyticsLogger.setUserID)
    }

    func log(_ error: Error) {
        let nsError = error as NSError
        crashlyticsLogger.record(
            error: NSError(
                domain: nsError.domain,
                code: nsError.code,
                userInfo: nsError.userInfo + [
                    "nserror-localizedDescription": nsError.localizedDescription,
                    "nserror-debugDescription": nsError.debugDescription,
                ]
            )
        )
    }
}
