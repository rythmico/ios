import Foundation

final class AnalyticsServiceDummy: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {}
    func reset() {}
}
