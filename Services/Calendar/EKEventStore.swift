import Foundation
import EventKit

protocol EKCalendarProtocol {
    var title: String { get }
    var type: EKCalendarType { get }
}

extension EKCalendar: EKCalendarProtocol {}

protocol CalendarAccessProviderProtocol {
    static func authorizationStatus(for entityType: EKEntityType) -> EKAuthorizationStatus
    func requestAccess(to entityType: EKEntityType, completion: @escaping EKEventStoreRequestAccessCompletionHandler)
    func calendars(for entityType: EKEntityType) -> [EKCalendarProtocol]
}

extension EKEventStore: CalendarAccessProviderProtocol {
    func calendars(for entityType: EKEntityType) -> [EKCalendarProtocol] {
        calendars(for: entityType).map { (calendar: EKCalendar) in calendar as EKCalendarProtocol }
    }
}

extension EKAuthorizationStatus {
    var isGranted: Bool? {
        switch self {
        case .notDetermined:
            return nil
        case .authorized:
            return true
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
}
