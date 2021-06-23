import FoundationSugar

final class AnalyticsServiceDummy: AnalyticsServiceProtocol {
    func identify(_ profile: AnalyticsUserProfile) {}
    func update(_ props: AnalyticsEvent.Props) {}
    func track(_ event: AnalyticsEvent) {}
    func reset() {}
}
