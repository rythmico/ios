#if RYTHMICO
import StudentDTO
#elseif TUTOR
import TutorDTO
#endif

extension APIEvent {
    init?(userInfo: [AnyHashable: Any]) {
        guard let eventRawValue = userInfo["event"] as? String else {
            return nil
        }
        self.init(rawValue: eventRawValue)
    }
}
