import Foundation
import EventKit

struct EKCalendarFake: EKCalendarProtocol {
    var title = CalendarSyncStatusProvider.Const.calendarName
    var type: EKCalendarType = .subscription
}

final class EKEventStoreStub: CalendarAccessProviderProtocol {
    static var initialAuthorizationStatus: EKAuthorizationStatus = .notDetermined
    var accessRequestResult: (Bool, Error?)
    var calendars: [EKCalendarProtocol]

    init(accessRequestResult: (Bool, Error?), calendars: [EKCalendarProtocol]) {
        self.accessRequestResult = accessRequestResult
        self.calendars = calendars
    }

    static func authorizationStatus(for entityType: EKEntityType) -> EKAuthorizationStatus {
        initialAuthorizationStatus
    }

    func requestAccess(to entityType: EKEntityType, completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
        completion(accessRequestResult.0, accessRequestResult.1)
    }

    func calendars(for entityType: EKEntityType) -> [EKCalendarProtocol] {
        calendars
    }
}

final class EKEventStoreDummy: CalendarAccessProviderProtocol {
    static func authorizationStatus(for entityType: EKEntityType) -> EKAuthorizationStatus { .notDetermined }
    func requestAccess(to entityType: EKEntityType, completion: @escaping EKEventStoreRequestAccessCompletionHandler) { }
    func calendars(for entityType: EKEntityType) -> [EKCalendarProtocol] { [] }
}
