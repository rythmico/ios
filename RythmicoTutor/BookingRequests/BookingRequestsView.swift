import SwiftUI
import Combine

struct BookingRequestsView: View {
    @ObservedObject
    private var coordinator: APIActivityCoordinator<BookingRequestsGetRequest>
    @ObservedObject
    private var repository = Current.bookingRequestRepository
    @ObservedObject
    private var applicationRepository = Current.bookingApplicationRepository
    @ObservedObject
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator

    @ObservedObject
    private var state = Current.state

    init?() {
        guard let coordinator = Current.sharedCoordinator(for: \.bookingRequestFetchingService) else {
            return nil
        }
        self.coordinator = coordinator
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var requests: [BookingRequest] {
        // Optimization to remove already-applied requests before fetch.
        repository.items.filter { request in
            !applicationRepository.items.contains {
                $0.statusInfo.status == .pending && $0.bookingRequestId == request.id
            }
        }
    }

    var body: some View {
        List {
            Section(
                header: HStack(spacing: .spacingUnit * 2) {
                    Text("UPCOMING")
                    if isLoading {
                        ActivityIndicator()
                    }
                }
            ) {
                ForEach(requests) { request in
                    BookingRequestCell(
                        request: request,
                        selection: $state.requestsContext.selectedRequest
                    )
                }
            }
        }
        .listStyle(GroupedListStyle())
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)

        .onReceive(state.onRequestsUpcomingTabRootPublisher, perform: coordinator.startToIdle)
        .onDisappear(perform: coordinator.cancel)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)

        .onSuccess(coordinator, perform: requestPushNotificationAuth)
        .alert(
            error: pushNotificationAuthCoordinator.status.failedValue,
            dismiss: pushNotificationAuthCoordinator.dismissFailure
        )
    }

    func requestPushNotificationAuth(_: [BookingRequest]) {
        pushNotificationAuthCoordinator.requestAuthorization()
    }
}

private extension AppState {
    var onRequestsUpcomingTabRootPublisher: AnyPublisher<Void, Never> {
        $tab.combineLatest($requestsTab, $requestsContext)
            .filter { $0 == (.requests, .upcoming, .none) }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsView()
    }
}
#endif
