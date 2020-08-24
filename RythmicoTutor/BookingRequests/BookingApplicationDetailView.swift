import SwiftUI
import SwiftUIMapView

struct BookingApplicationDetailView: View {
    @Environment(\.presentationMode)
    private var presentationMode

    private let bookingApplication: BookingApplication

    private let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private let timeFormatter = Current.dateFormatter(format: .time(.short))
    private let statusDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short)

    init(bookingApplication: BookingApplication) {
        self.bookingApplication = bookingApplication
    }

    var status: String { bookingApplication.statusInfo.status.summary }
    var statusColor: Color { bookingApplication.statusInfo.status.color }
    var statusDate: String { statusDateFormatter.localizedString(for: bookingApplication.statusInfo.date, relativeTo: Current.date()) }
    var title: String { "\(bookingApplication.student.name) - \(bookingApplication.instrument.name) Request" }
    var submittedBy: String { bookingApplication.submitterName }
    var startDate: String { dateFormatter.string(from: bookingApplication.schedule.startDate) }
    var time: String { timeFormatter.string(from: bookingApplication.schedule.startDate) }
    var duration: String { "\(bookingApplication.schedule.duration) minutes" }
    var name: String { bookingApplication.student.name }
    var age: String { "\(bookingApplication.student.age)" }
    var gender: String { bookingApplication.student.gender.name }
    var about: String? { bookingApplication.student.about.isEmpty ? nil : bookingApplication.student.about }
    var submitterPrivateNote: String { bookingApplication.submitterPrivateNote.isEmpty ? "None" : bookingApplication.submitterPrivateNote }
    var submitterPrivateNoteOpacity: Double { bookingApplication.submitterPrivateNote.isEmpty ? 0.5 : 1 }

    var body: some View {
        List {
            Section(header: Text("STATUS")) {
                HStack(spacing: .spacingUnit * 2) {
                    Dot(color: statusColor)
                    HStack(spacing: .spacingMedium) {
                        Text(status)
                            .foregroundColor(.primary)
                            .font(.body)
                        Spacer(minLength: 0)
                        TickingText(self.statusDate)
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
            }
            Section(header: Text("REQUEST DETAILS")) {
                TitleCell(title: "Submitted by", detail: submittedBy)
            }
            Section(header: Text("LESSON SCHEDULE DETAILS")) {
                TitleCell(title: "Start Date", detail: startDate)
                TitleCell(title: "Time", detail: time)
                TitleCell(title: "Duration", detail: duration)
            }
            Section(header: Text("STUDENT DETAILS")) {
                TitleCell(title: "Name", detail: name)
                TitleCell(title: "Age", detail: age)
                TitleCell(title: "Gender", detail: gender)
                about.map { about in
                    VStack(alignment: .leading, spacing: .spacingUnit) {
                        Text("About")
                            .foregroundColor(.primary)
                            .font(.body)
                        Text(about)
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                    .padding(.vertical, .spacingUnit)
                }
            }
            Section(header: Text("PRIVATE NOTE")) {
                Text(submitterPrivateNote)
                    .foregroundColor(Color.secondary.opacity(submitterPrivateNoteOpacity))
                    .font(.body)
                    .padding(.vertical, .spacingUnit)
            }
            Section(
                header: Text("ADDRESS DETAILS"),
                footer: Text("Exact location and address will be provided if you're selected.")
            ) {
                AddressMapCell(addressInfo: bookingApplication.addressInfo)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(title), displayMode: .inline)
        .onRoute(perform: handleRoute)
    }

    private func handleRoute(_ route: Route) {
        switch route {
        case .bookingRequests, .bookingApplications:
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#if DEBUG
struct BookingApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationDetailView(bookingApplication: .longStub)
    }
}
#endif
