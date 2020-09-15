import SwiftUI

struct BookingRequestsView: View, VisibleView {
    @ObservedObject
    private var coordinator: APIActivityCoordinator<BookingRequestsGetRequest>
    @ObservedObject
    private var repository = Current.bookingRequestRepository
    @ObservedObject
    private var applicationRepository = Current.bookingApplicationRepository
    @ObservedObject
    private var pushNotificationAuthCoordinator = Current.pushNotificationAuthorizationCoordinator

    @State
    private var selectedBookingRequest: BookingRequest?
    @State
    private(set) var isVisible = false; var isVisibleBinding: Binding<Bool> { $isVisible }

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
        VStack(spacing: .spacingMedium) {
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
                        NavigationLink(
                            destination: BookingRequestDetailView(bookingRequest: request),
                            tag: request,
                            selection: $selectedBookingRequest,
                            label: { BookingRequestCell(request: request) }
                        )
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .visible(self)

        .onAppearOrForeground(self, perform: coordinator.startToIdle)
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

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsView()
    }
}
#endif
