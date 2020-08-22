import SwiftUI

struct BookingApplicationsView: View {
    @ObservedObject
    private var coordinator: APIActivityCoordinator<BookingApplicationsGetRequest>
    @ObservedObject
    private var repository = Current.bookingApplicationRepository

    private let scheduleFormatter = Current.dateFormatter(format: .custom("d MMM '@' HH:mm"))
    private let statusDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short)

    @State
    private var selectedBookingApplication: BookingApplication?

    init?() {
        guard let coordinator = Current.coordinator(for: \.bookingApplicationFetchingService) else {
            return nil
        }
        self.coordinator = coordinator
    }

    var isLoading: Bool { coordinator.state.isLoading }
    var error: Error? { coordinator.state.failureValue }
    var applications: [BookingApplication] { repository.items }

    var body: some View {
        VStack(spacing: .spacingMedium) {
            List {
                Section(
                    header: HStack {
                        Text("PENDING")
                        if isLoading {
                            ActivityIndicator(style: .medium)
                                .transition(AnyTransition.opacity.combined(with: .scale))
                        }
                    }
                ) {
                    ForEach(applications) { application in
                        NavigationLink(
                            destination: BookingApplicationDetailView(bookingApplication: application),
                            tag: application,
                            selection: self.$selectedBookingApplication
                        ) {
                            HStack(spacing: .spacingUnit * 2) {
                                Dot(color: application.statusInfo.status.color)
                                HStack(spacing: .spacingMedium) {
                                    VStack(alignment: .leading) {
                                        Text(self.title(for: application))
                                            .foregroundColor(.primary)
                                            .font(.body)
                                        Text(self.subtitle(for: application))
                                            .foregroundColor(.secondary)
                                            .font(.callout)
                                    }
                                    Spacer(minLength: 0)
                                    TickingText(self.statusDate(for: application))
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                }
                            }
                            .padding(.vertical, .spacingUnit)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
        .onAppear(perform: coordinator.run)
        .onSuccess(coordinator, perform: repository.setItems)
        .alertOnFailure(coordinator)
    }

    private func title(for application: BookingApplication) -> String {
        "\(application.student.name) - \(application.instrument.name)"
    }

    private func subtitle(for application: BookingApplication) -> String {
        let startDate = scheduleFormatter.string(from: application.schedule.startDate)
        let status = application.statusInfo.status.title
        return [startDate, status].joined(separator: " • ")
    }

    private func statusDate(for application: BookingApplication) -> String {
        let date = Current.date()
        guard application.statusInfo.date.distance(to: date) >= 60 else {
            return "now"
        }
        return statusDateFormatter.localizedString(
            for: application.statusInfo.date,
            relativeTo: date
        )
    }
}

#if DEBUG
struct BookingApplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationsView()
    }
}
#endif
