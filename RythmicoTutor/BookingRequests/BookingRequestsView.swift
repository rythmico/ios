import SwiftUI

struct BookingRequestsView: View {
    @ObservedObject
    private var coordinator: APIActivityCoordinator<BookingRequestsGetRequest>
    @ObservedObject
    private var repository = Current.bookingRequestRepository

    private let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))

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
                            label: {
                                HStack(spacing: .spacingMedium) {
                                    VStack(alignment: .leading) {
                                        Text("\(request.student.name) - \(request.instrument.name)")
                                            .foregroundColor(.primary)
                                            .font(.body)
                                        Text("\(request.schedule.startDate, formatter: self.scheduleFormatter)")
                                            .foregroundColor(.secondary)
                                            .font(.callout)
                                    }
                                    Spacer(minLength: 0)
                                    Text(request.postcode)
                                        .foregroundColor(.secondary)
                                        .font(.body)
                                }
                                .padding(.vertical, .spacingUnit)
                            }
                        )
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .onAppear(perform: fetchOnAppearOnce)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private static var didAppear = false
    private func fetchOnAppearOnce() {
        guard !Self.didAppear else { return }
        coordinator.run()
        Self.didAppear = true
    }
}

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsView()
    }
}
#endif
