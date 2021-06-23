import FoundationSugar

class CalendarSyncStatusProviderBase: ObservableObject {
    enum Status {
        case notDetermined
        case unauthorized
//        case failed(Error)
        case notSynced
        case synced
    }

    @Published /*protected(set)*/ var status: Status = .notDetermined

    func requestAccess() {}
    func refreshStatus() {}
}

final class CalendarSyncStatusProvider: CalendarSyncStatusProviderBase {
    enum Const {
        #if RYTHMICO
        static let calendarName = "Rythmico"
        #elseif TUTOR
        static let calendarName = "Rythmico Tutor"
        #endif
    }

    private let accessProvider: CalendarAccessProviderProtocol

    init(accessProvider: CalendarAccessProviderProtocol) {
        self.accessProvider = accessProvider
        super.init()
        refreshStatus()
    }

    override func requestAccess() {
        accessProvider.requestAccess(to: .event) { [self] isGranted, error in
//            if let error = error {
//                status = .failed(error)
//            } else {
                setStatusForGranted(isGranted)
//            }
        }
    }

    override func refreshStatus() {
        let authorizationStatus = type(of: accessProvider).authorizationStatus(for: .event)
        setStatusForGranted(authorizationStatus.isGranted)
    }

    private func setStatusForGranted(_ isGranted: Bool?) {
        switch isGranted {
        case .none:
            status = .notDetermined
        case .some(true):
            status = accessProvider.calendars(for: .event).contains(where: isSyncedCalendar)
                ? .synced
                : .notSynced
        case .some(false):
            status = .unauthorized
        }
    }

    private func isSyncedCalendar(_ calendar: EKCalendarProtocol) -> Bool {
        calendar.title == Const.calendarName && calendar.type == .subscription
    }
}

extension CalendarSyncStatusProviderBase.Status {
    var isNotDetermined: Bool {
        guard case .notDetermined = self else { return false }
        return true
    }

    var isUnauthorized: Bool {
        guard case .unauthorized = self else { return false }
        return true
    }

//    var error: Error? {
//        guard case .failed(let error) = self else { return nil }
//        return error
//    }

    var isNotSynced: Bool {
        guard case .notSynced = self else { return false }
        return true
    }

    var isSynced: Bool {
        guard case .synced = self else { return false }
        return true
    }
}
