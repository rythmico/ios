import SwiftUIEncore
import ComposableNavigator

struct BookingRequestDetailScreen: Screen {
    let bookingRequest: BookingRequest
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: BookingRequestDetailScreen) in
                    BookingRequestDetailView(bookingRequest: screen.bookingRequest)
                },
                nesting: {
                    BookingRequestApplyScreen.Builder()
                }
            )
        }
    }
}

struct BookingRequestDetailView: View {
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    var bookingRequest: BookingRequest

    private static let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private static let timeFormatter = Current.dateFormatter(format: .preset(time: .short))

    var title: String { "\(bookingRequest.student.name) - \(bookingRequest.instrument.assimilatedName) Request" }
    var submittedBy: String { bookingRequest.submitterName }
    var startDate: String { Self.dateFormatter.string(from: bookingRequest.schedule.startDate) }
    var time: String { Self.timeFormatter.string(from: bookingRequest.schedule.startDate) }
    var duration: String { bookingRequest.schedule.duration.title }
    var name: String { bookingRequest.student.name }
    var age: String { "\(bookingRequest.student.age)" }
    var about: String? { bookingRequest.student.about.isEmpty ? nil : bookingRequest.student.about }
    var privateNote: String { bookingRequest.privateNote.isEmpty ? "None" : bookingRequest.privateNote }
    var privateNoteOpacity: Double { bookingRequest.privateNote.isEmpty ? 0.5 : 1 }
    var postcode: String { bookingRequest.postcode }

    private func presentApplicationView() {
        navigator.go(to: BookingRequestApplyScreen(booking: bookingRequest), on: currentScreen)
    }

    var body: some View {
        VStack(spacing: 0) {
            List {
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
                    Text(privateNote)
                        .foregroundColor(.secondary.opacity(privateNoteOpacity))
                        .font(.body)
                        .padding(.vertical, .grid(1))
                }
                Section(
                    header: Text("ADDRESS DETAILS"),
                    footer: Text("Exact location and address will be provided if you're selected.")
                ) {
                    AddressMapCell(addressInfo: .postcode(bookingRequest.postcode))
                }
            }
            .listStyle(GroupedListStyle())

            FloatingView {
                RythmicoButton("Apply", style: .primary(), action: presentApplicationView)
            }
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
    }
}

#if DEBUG
struct BookingRequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestDetailView(bookingRequest: .stub)
    }
}
#endif
