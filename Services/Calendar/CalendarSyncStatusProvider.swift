import Foundation
import EventKit
import Combine

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

final class CalendarSyncStatusProvider: ObservableObject {
    enum Const {
        #if RYTHMICO
        static let calendarName = "Rythmico"
        #elseif TUTOR
        static let calendarName = "Rythmico Tutor"
        #endif
    }

    enum Status {
        case unauthorized
        case failed(Error)
        case notSynced
        case synced
    }

    @Published private(set) var status = Status.unauthorized

    private let accessProvider: CalendarAccessProviderProtocol

    init(accessProvider: CalendarAccessProviderProtocol) {
        self.accessProvider = accessProvider
        refreshStatus()
    }

    func requestAccess() {
        accessProvider.requestAccess(to: .event) { [self] isGranted, error in
            if let error = error {
                status = .failed(error)
            } else {
                setStatusForGranted(isGranted)
            }
        }
    }

    private func refreshStatus() {
        let authorizationStatus = type(of: accessProvider).authorizationStatus(for: .event)
        setStatusForGranted(authorizationStatus.isGranted)
    }

    private func setStatusForGranted(_ isGranted: Bool) {
        if isGranted {
            status = accessProvider.calendars(for: .event).contains(where: isSyncedCalendar)
                ? .synced
                : .notSynced
        } else {
            status = .unauthorized
        }
    }

    private func isSyncedCalendar(_ calendar: EKCalendarProtocol) -> Bool {
        calendar.title == Const.calendarName && calendar.type == .subscription
    }
}

private extension EKAuthorizationStatus {
    var isGranted: Bool {
        switch self {
        case .authorized:
            return true
        case .denied, .notDetermined, .restricted:
            return false
        @unknown default:
            return false
        }
    }
}
