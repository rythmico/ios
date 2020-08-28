import SwiftUI

struct BookingRequestsView: View {
    @ObservedObject
    private var coordinator: APIActivityCoordinator<BookingRequestsGetRequest>
    @ObservedObject
    private var repository = Current.bookingRequestRepository

    @State
    private var selectedBookingRequest: BookingRequest?

    init?() {
        guard let coordinator = Current.coordinator(for: \.bookingRequestFetchingService) else {
            return nil
        }
        self.coordinator = coordinator
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var requests: [BookingRequest] { repository.items }

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
        .onAppear(perform: fetchOnAppear)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    @State
    private var didAppear = false
    private func fetchOnAppear() {
        guard !didAppear else { return }
        coordinator.run()
        didAppear = true
    }
}

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsView()
    }
}
#endif
