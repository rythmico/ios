import Foundation

final class AnalyticsServiceDummy: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {}
    func track(_ event: AnalyticsEvent) {}
    func reset() {}
}
