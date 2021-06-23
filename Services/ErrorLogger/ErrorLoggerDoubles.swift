import FoundationSugar

final class ErrorLoggerDummy: ErrorLoggerProtocol {
    func log(_ error: Error) {}
}
