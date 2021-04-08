import Foundation

final class AnalyticsServiceDummy: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {}
    func track(event: AnalyticsEvent) {}
    func reset() {}
}
