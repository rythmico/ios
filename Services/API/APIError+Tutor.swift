import FoundationEncore

extension RythmicoAPIError {
    enum ErrorType: String {
        case unknown
        case appOutdated = "APP_OUTDATED"
        case tutorNotVerified = "TUTOR_NOT_VERIFIED"
    }
}
