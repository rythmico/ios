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
        guard let coordinator = Current.coordinator(for: \.bookingRequestFetchingService) else {
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
                    header: HStack {
                        Text("UPCOMING")
                        if isLoading {
                            ActivityIndicator(style: .medium)
                                .transition(AnyTransition.opacity.combined(with: .scale))
                        }
                    }
                ) {
                    ForEach(requests) { request in
                        NavigationLink(
                            destination: BookingRequestDetailView(bookingRequest: request),
                            tag: request,
                            selection: self.$selectedBookingRequest,
                            label: { BookingRequestCell(request: request) }
                        )
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .visible(self)
        .runCoordinator(coordinator, on: self)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
        .onAppear(perform: pushNotificationAuthCoordinator.requestAuthorization)
        .alert(
            error: self.pushNotificationAuthCoordinator.status.failedValue,
            dismiss: pushNotificationAuthCoordinator.dismissFailure
        )
    }
}

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsView()
    }
}
#endif
