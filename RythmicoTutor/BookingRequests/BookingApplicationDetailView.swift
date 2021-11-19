import SwiftUIEncore
import PhoneNumberKit
import ComposableNavigator

struct BookingApplicationDetailScreen: Screen {
    let bookingApplication: BookingApplication
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: BookingApplicationDetailScreen) in
                    BookingApplicationDetailView(bookingApplication: screen.bookingApplication)
                }
            )
        }
    }
}

struct BookingApplicationDetailView: View {
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    private static let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private static let timeFormatter = Current.dateFormatter(format: .preset(time: .short))
    private static let statusDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .short, precise: true)

    @State
    private var retractionPromptSheetPresented = false
    @StateObject
    private var retractionCoordinator = Current.bookingApplicationRetractionCoordinator()

    let bookingApplication: BookingApplication

    var status: String { bookingApplication.statusInfo.status.summary }
    var statusColor: Color { bookingApplication.statusInfo.status.color }
    var statusDate: String { Self.statusDateFormatter.localizedString(for: bookingApplication.statusInfo.date, relativeTo: Current.date()) }
    var title: String { "\(bookingApplication.student.name) - \(bookingApplication.instrument.assimilatedName) Request" }
    var submittedBy: String { bookingApplication.submitterName }
    var startDate: String { Self.dateFormatter.string(from: bookingApplication.schedule.startDate) }
    var time: String { Self.timeFormatter.string(from: bookingApplication.schedule.startDate) }
    var duration: String { bookingApplication.schedule.duration.title }
    var name: String { bookingApplication.student.name }
    var age: String { "\(bookingApplication.student.age)" }
    var about: String? { bookingApplication.student.about.isEmpty ? nil : bookingApplication.student.about }
    var submitterPrivateNote: String { bookingApplication.submitterPrivateNote.isEmpty ? "None" : bookingApplication.submitterPrivateNote }
    var submitterPrivateNoteOpacity: Double { bookingApplication.submitterPrivateNote.isEmpty ? 0.5 : 1 }

    var retractAction: Action? {
        bookingApplication.statusInfo.status == .pending
            ? { retractionCoordinator.run(with: .init(bookingApplicationId: bookingApplication.id)) }
            : nil
    }

    var body: some View {
        List {
            Section(header: Text("STATUS")) {
                HStack(spacing: .grid(2)) {
                    Dot(color: statusColor)
                    HStack(spacing: .grid(5)) {
                        Text(status)
                            .foregroundColor(.primary)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        TickingText(statusDate)
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                }
            }
            Section(header: Text("REQUEST DETAILS")) {
                TitleCell(title: "Submitted by", detail: submittedBy)
                bookingApplication.phoneNumber.map {
                    PhoneNumberCell(phoneNumber: $0)
                }
            }
            Section(header: Text("LESSON SCHEDULE DETAILS")) {
                TitleCell(title: "Start Date", detail: startDate)
                TitleCell(title: "Time", detail: time)
                TitleCell(title: "Duration", detail: duration)
            }
            Section(header: Text("STUDENT DETAILS")) {
                TitleCell(title: "Name", detail: name)
                TitleCell(title: "Age", detail: age)
                about.map { about in
                    VStack(alignment: .leading, spacing: .grid(1)) {
                        Text("About")
                            .foregroundColor(.primary)
                            .font(.body)
                        Text(about)
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                    .padding(.vertical, .grid(1))
                }
            }
            Section(header: Text("PRIVATE NOTE")) {
                Text(submitterPrivateNote)
                    .foregroundColor(.secondary.opacity(submitterPrivateNoteOpacity))
                    .font(.body)
                    .padding(.vertical, .grid(1))
            }
            Section(
                header: Text("ADDRESS DETAILS"),
                footer: Text("Exact location and address will be provided if you're selected.")
            ) {
                // TODO: upcoming
//                AddressMapCell(addressInfo: bookingApplication.addressInfo)
            }
            retractAction.map { retractAction in
                GroupedButton(title: "Retract Application", action: promptForRetraction) {
                    if retractionCoordinator.state.isLoading {
                        ActivityIndicator()
                    }
                }
                .accentColor(.red)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(title), displayMode: .inline)
        .actionSheet(isPresented: $retractionPromptSheetPresented) {
            ActionSheet(
                title: Text("Are you sure you'd like to retract your application?"),
                buttons: [
                    .destructive(Text("Retract"), action: retractAction),
                    .cancel()
                ]
            )
        }
        .disabled(retractionCoordinator.state.isLoading)
        .alertOnFailure(retractionCoordinator)
        .onSuccess(retractionCoordinator, perform: didRetractBookingApplication)
    }

    private func promptForRetraction() {
        retractionPromptSheetPresented = true
    }

    private func didRetractBookingApplication(_ retractedApplication: BookingApplication) {
        Current.bookingApplicationRepository.replaceById(retractedApplication)
        navigator.goBack(to: .root)
    }
}

#if DEBUG
struct BookingApplicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingApplicationDetailView(bookingApplication: .longStub)
        BookingApplicationDetailView(bookingApplication: .stub(.stub(.selected)))
    }
}
#endif
