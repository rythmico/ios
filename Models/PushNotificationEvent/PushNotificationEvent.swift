import FoundationEncore

extension PushNotificationEvent {
    init?(userInfo: [AnyHashable: Any]) {
        guard let eventRawValue = userInfo["event"] as? String else {
            return nil
        }
        self.init(rawValue: eventRawValue)
    }
}
