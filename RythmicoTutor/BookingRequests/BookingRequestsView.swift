import SwiftUI

struct BookingRequestsView: View {
    @ObservedObject
    private var coordinator: BookingRequestFetchingCoordinator
    @ObservedObject
    private var repository = Current.bookingRequestRepository

    private let lessonDateFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
    private let bookingDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short)

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var requests: [BookingRequest] { repository.latestBookingRequests }

    init?() {
        guard let coordinator = Current.bookingRequestFetchingCoordinator() else {
            return nil
        }
        self.coordinator = coordinator
    }

    var body: some View {
        VStack(spacing: .spacingMedium) {
            List {
                Section(
                    header: HStack {
                        Text("LATEST")
                        if isLoading {
                            ActivityIndicator(style: .medium)
                                .transition(AnyTransition.opacity.combined(with: .scale))
                        }
                    }
                ) {
                    ForEach(requests) { request in
                        HStack(spacing: .spacingSmall) {
                            VStack(alignment: .leading) {
                                Text(request.student.name)
                                    .foregroundColor(.primary)
                                    .font(.body)
                                Text("\(request.schedule.startDate, formatter: self.lessonDateFormatter) • \(request.postcode)")
                                .foregroundColor(.secondary)
                                .font(.callout)
                            }
                            Spacer(minLength: 0)
                            TickingText(
                                self.bookingDateFormatter.localizedString(
                                    for: request.createdAt,
                                    relativeTo: Current.date()
                                )
                            )
                            .foregroundColor(.secondary)
                            .font(Font.caption.weight(.medium))
                        }
                        .padding(.vertical, .spacingUnit)
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .alert(error: self.error, dismiss: coordinator.dismissFailure)
        .onAppear(perform: coordinator.fetchBookingRequests)
    }
}

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestsView()
    }
}
#endif
