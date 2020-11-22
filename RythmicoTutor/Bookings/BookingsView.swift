import SwiftUI
import Combine

struct BookingsView: View {
    typealias Coordinator = APIActivityCoordinator<BookingsGetRequest>

    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var state = Current.state
    @ObservedObject
    private var coordinator = Current.sharedCoordinator(for: \.bookingsFetchingService)!
    @ObservedObject
    private var repository = Current.bookingsRepository
    @ObservedObject
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var bookings: [Booking] { repository.items }

    var body: some View {
        LessonsCollectionView(currentBookings: bookings)
            .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)

            .onReceive(coordinator.$state.zip(state.onScheduleUpcomingTabRootPublisher).b, perform: fetch)
            // FIXME: double HTTP request for some reason
            // .onDisappear(perform: coordinator.cancel)
            .onSuccess(coordinator, perform: repository.setItems)
            .alertOnFailure(coordinator)

            .onSuccess(coordinator, perform: requestPushNotificationAuth)
            .alert(
                error: pushNotificationAuthCoordinator.status.failedValue,
                dismiss: pushNotificationAuthCoordinator.dismissFailure
            )
    }

    func requestPushNotificationAuth(_: Any) {
        pushNotificationAuthCoordinator.requestAuthorization()
    }

    private func fetch() {
        guard Current.sceneState == .active else { return }
        coordinator.startToIdle()
    }
}

private extension AppState {
    var onScheduleUpcomingTabRootPublisher: AnyPublisher<Void, Never> {
        $tab//.combineLatest($requestsTab, $requestsContext)
            .filter { $0 == (.schedule) }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

#if DEBUG
struct BookingsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingsView()
    }
}
#endif
