import SwiftUI
import SwiftUIMapView

struct BookingRequestDetailView: View {
    @Environment(\.presentationMode)
    private var presentationMode
    @ObservedObject
    private var state = Current.state

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

    private func presentApplicationView() { state.requestsContext.isApplyingToRequest = true }

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
                    Text(privateNote)
                        .foregroundColor(.secondary.opacity(privateNoteOpacity))
                        .font(.body)
                        .padding(.vertical, .spacingUnit)
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
                Button("Apply", action: presentApplicationView).primaryStyle()
            }
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
        .sheet(isPresented: $state.requestsContext.isApplyingToRequest) {
            BookingRequestApplyView(booking: bookingRequest)
        }
        .onReceive(state.$requestsContext, perform: requestsContextChanged)
    }

    // FIXME: this is a workaround for this View not dismissing on requestsContext = .none.
    // I suspect it's a SwiftUI bug where if the NavigationLink is specifically inside a List (BookingRequestsView's List),
    // programatic navigation does not work, so we're forced to dismiss through presentationMode by observing.
    private func requestsContextChanged(_ context: AppState.RequestsContext) {
        if context.selectedRequest == nil {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#if DEBUG
struct BookingRequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestDetailView(bookingRequest: .stub)
    }
}
#endif
