import Foundation

final class AnalyticsServiceDummy: AnalyticsServiceProtocol {
    func identify(distinctId: String) {}
    func time(event: String) {}
    func track(event: String?, properties: Properties?) {}
    func reset() {}
}
