import FoundationEncore

final class CalendarSyncStatusProviderStub: CalendarSyncStatusProviderBase {
    private(set) var initialStatus: Status
    private(set) var refreshedStatus: Status

    init(initialStatus: Status, refreshedStatus: Status) {
        self.initialStatus = initialStatus
        self.refreshedStatus = refreshedStatus
        super.init()
    }

    override func requestAccess() {
        status = initialStatus
    }

    override func refreshStatus() {
        status = refreshedStatus
    }
}

final class CalendarSyncStatusProviderDummy: CalendarSyncStatusProviderBase {}
