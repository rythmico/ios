import Foundation

final class AnalyticsServiceDummy: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {}
    func time(_ eventName: AnalyticsEvent.Name) {}
    func track(_ event: AnalyticsEvent) {}
    func reset() {}
}
