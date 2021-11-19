import AppCenter
import AppCenterCrashes
import Combine
import FoundationEncore

protocol ErrorLoggerProtocol {
    func log(_ error: Error)
}

final class ErrorLogger: ErrorLoggerProtocol {
    init() {}

    func log(_ error: Error) {
        let nsError = error as NSError
        let properties = nsError.userInfo.compactMapValues { $0 as? String } + [
            "error-legibleDescription": error.legibleDescription,
            "error-legibleLocalizedDescription": error.legibleLocalizedDescription,
            "nserror-localizedDescription": nsError.localizedDescription,
            "nserror-debugDescription": nsError.debugDescription,
        ]
        Crashes.trackError(error, properties: properties, attachments: nil)
    }
}
