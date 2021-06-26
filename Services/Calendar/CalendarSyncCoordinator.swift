import SwiftUISugar
import Combine

final class CalendarSyncCoordinator: ObservableObject {
    @Published
    var permissionsNeededAlert: Alert?
    @Published
    private(set) var error: Error?
    private var isSubscriptionInProgress = false

    private var calendarSyncStatusProvider: CalendarSyncStatusProviderBase
    private var calendarInfoFetchingCoordinator: APIActivityCoordinator<GetCalendarInfoRequest>
    private var eventEmitter: NotificationCenter
    private var urlOpener: URLOpener
    private var cancellables = [AnyCancellable]()

    init(
        calendarSyncStatusProvider: CalendarSyncStatusProviderBase,
        calendarInfoFetchingCoordinator: APIActivityCoordinator<GetCalendarInfoRequest>,
        eventEmitter: NotificationCenter,
        urlOpener: URLOpener
    ) {
        self.calendarSyncStatusProvider = calendarSyncStatusProvider
        self.calendarInfoFetchingCoordinator = calendarInfoFetchingCoordinator
        self.eventEmitter = eventEmitter
        self.urlOpener = urlOpener

        self.calendarSyncStatusProvider.objectWillChange.receive(on: DispatchQueue.main).sink(receiveValue: objectWillChange.send).store(in: &cancellables)
        self.calendarInfoFetchingCoordinator.objectWillChange.receive(on: DispatchQueue.main).sink(receiveValue: objectWillChange.send).store(in: &cancellables)
        self.eventEmitter.publisher(for: .EKEventStoreChanged).map { _ in () }.sink(receiveValue: eventStoreChanged).store(in: &cancellables)
    }

    var isSyncingCalendar: Bool {
        calendarInfoFetchingCoordinator.state.isLoading || isSubscriptionInProgress
    }

    var enableCalendarSyncAction: Action? {
        switch calendarSyncStatusProvider.status {
        case .notDetermined: return requestCalendarAccess
        case .unauthorized: return presentCalendarPermissionsNeededAlert
        case .notSynced: return fetchCalendarInfo
        case .synced: return nil
        }
    }

    var goToCalendarAction: Action? {
        enableCalendarSyncAction == nil ? { Current.urlOpener.open("calshow://") } : nil
    }

    var isCalendarSyncEnabled: Bool {
        switch calendarSyncStatusProvider.status {
        case .notDetermined, .unauthorized, .notSynced:
            return false
        case .synced:
            return true
        }
    }

    func dismissError() {
        error = nil
    }

    private func requestCalendarAccess() {
        calendarSyncStatusProvider.$status
            .filter(\.isNotSynced)
            .map { _ in () }
            .sink(receiveValue: fetchCalendarInfo)
            .store(in: &cancellables)
        calendarSyncStatusProvider.requestAccess()
    }

    private func presentCalendarPermissionsNeededAlert() {
        permissionsNeededAlert = Alert(
            title: Text("Please Allow Access"),
            message: Text("Please allow calendar access in settings in order to enable calendar sync."),
            primaryButton: .default(Text("Settings")) { self.urlOpener.openSettings() },
            secondaryButton: .cancel(Text("Not Now"))
        )
    }

    private func fetchCalendarInfo() {
        calendarInfoFetchingCoordinator.$state
            .compactMap(\.successValue)
            .sink(receiveValue: subscribeToCalendar)
            .store(in: &cancellables)
        calendarInfoFetchingCoordinator.runToIdle()
    }

    private func subscribeToCalendar(_ info: CalendarInfo) {
        do {
            try Current.urlOpener.subscribeToCalendar(with: info)
            isSubscriptionInProgress = true

            // Timeout for EKEventStore to emit notification of change.
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
                self?.eventStoreChanged()
            }
        } catch {
            self.error = error
        }
    }

    private func eventStoreChanged() {
        isSubscriptionInProgress = false
        calendarSyncStatusProvider.refreshStatus()
    }
}
