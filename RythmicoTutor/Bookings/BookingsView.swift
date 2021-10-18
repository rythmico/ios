import SwiftUIEncore
import Combine

struct BookingsView: View {
    @Environment(\.scenePhase)
    private var scenePhase
    @ObservedObject
    private var tabSelection = Current.tabSelection
    @ObservedObject
    private var coordinator = Current.bookingsFetchingCoordinator
    @ObservedObject
    private var repository = Current.bookingsRepository
    @ObservedObject
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue() }
    var bookings: [Booking] { repository.items }

    var body: some View {
        LessonsCollectionView(currentBookings: bookings)
            .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)

            .onReceive(shouldFetchPublisher(), perform: fetch)
            // FIXME: double HTTP request for some reason
            // .onDisappear(perform: coordinator.cancel)
            .onSuccess(coordinator, perform: repository.setItems)
            .onSuccess(coordinator, perform: requestPushNotificationAuth)
            .multiModal {
                $0.alertOnFailure(coordinator)
                $0.alert(
                    error: pushNotificationAuthCoordinator.status.failedValue,
                    dismiss: pushNotificationAuthCoordinator.dismissFailure
                )
            }
    }

    func requestPushNotificationAuth(_: Any) {
        pushNotificationAuthCoordinator.requestAuthorization()
    }

    private func shouldFetchPublisher() -> AnyPublisher<Void, Never> {
        coordinator.$state.zip(onScheduleUpcomingTabRootPublisher()).b
    }

    private func onScheduleUpcomingTabRootPublisher() -> AnyPublisher<Void, Never> {
        tabSelection.$mainTab//.combineLatest($requestsTab, $requestsContext)
            .filter { $0 == (.schedule) }
            .mapToVoid()
            .eraseToAnyPublisher()
    }

    private func fetch() {
        guard Current.sceneState() == .active else { return }
        coordinator.startToIdle()
    }
}

#if DEBUG
struct BookingsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingsView()
    }
}
#endif
