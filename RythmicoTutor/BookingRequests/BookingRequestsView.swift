import SwiftUI

struct BookingRequestsView: View {
    private let coordinator = Current.bookingRequestFetchingCoordinator()!
    @ObservedObject
    private var repository = Current.bookingRequestRepository

    private let lessonDateFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
    private let bookingDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short)

    var requests: [BookingRequest] { repository.latestBookingRequests }
    var error: Error? { coordinator.state.failureValue }

    var body: some View {
        List {
            Section(header: Text("LATEST")) {
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
                        Text("\(request.createdAt, formatter: self.bookingDateFormatter)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.vertical, .spacingUnit)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .alert(error: self.error, dismiss: coordinator.dismissFailure)
        .onAppear(perform: coordinator.fetchBookingRequests)
    }
}

#if DEBUG
struct BookingRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        Current.userAuthenticated()

        Current.bookingRequestFetchingService = BookingRequestFetchingServiceStub(
            result: .success([.stub, .longStub]),
            delay: nil
        )

        return BookingRequestsView()
    }
}
#endif
