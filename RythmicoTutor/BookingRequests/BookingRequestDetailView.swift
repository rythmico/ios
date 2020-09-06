import SwiftUI
import SwiftUIMapView

struct BookingRequestDetailView: View, RoutableView {
    @Environment(\.presentationMode)
    private var presentationMode

    private let bookingRequest: BookingRequest

    private let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private let timeFormatter = Current.dateFormatter(format: .time(.short))

    init(bookingRequest: BookingRequest) {
        self.bookingRequest = bookingRequest
    }

    var title: String { "\(bookingRequest.student.name) - \(bookingRequest.instrument.name) Request" }
    var submittedBy: String { bookingRequest.submitterName }
    var startDate: String { dateFormatter.string(from: bookingRequest.schedule.startDate) }
    var time: String { timeFormatter.string(from: bookingRequest.schedule.startDate) }
    var duration: String { "\(bookingRequest.schedule.duration) minutes" }
    var name: String { bookingRequest.student.name }
    var age: String { "\(bookingRequest.student.age)" }
    var gender: String { bookingRequest.student.gender.name }
    var about: String? { bookingRequest.student.about.isEmpty ? nil : bookingRequest.student.about }
    var privateNote: String { bookingRequest.privateNote.isEmpty ? "None" : bookingRequest.privateNote }
    var privateNoteOpacity: Double { bookingRequest.privateNote.isEmpty ? 0.5 : 1 }

    @State
    private var isMapOpeningSheetPresented = false
    private func presentMapActionSheet() { isMapOpeningSheetPresented = true }
    @State
    private var mapOpeningError: Error?

    var postcode: String { bookingRequest.postcode }

    @State
    private var isApplicationViewPresented = false
    private func presentApplicationView() { isApplicationViewPresented = true }

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
                    Text(privateNote)
                        .foregroundColor(Color.secondary.opacity(privateNoteOpacity))
                        .font(.body)
                        .padding(.vertical, .spacingUnit)
                }
                Section(
                    header: Text("ADDRESS DETAILS"),
                    footer: Text("Exact location and address will be provided if you're selected.")
                ) {
                    VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                        StaticMapView(showsCoordinate: false)
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: .spacingUnit * 2, style: .continuous))
                            .onTapGesture(perform: presentMapActionSheet)
                        Text(postcode)
                            .foregroundColor(.primary)
                            .font(.body)
                    }
                    .padding(.vertical, .spacingUnit * 2)
                }
            }
            .listStyle(GroupedListStyle())

            FloatingView {
                Button("Apply", action: presentApplicationView).primaryStyle()
            }
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
        .mapOpeningSheet(
            isPresented: $isMapOpeningSheetPresented,
            intent: .search(query: bookingRequest.postcode),
            error: $mapOpeningError
        )
        .sheet(isPresented: $isApplicationViewPresented) {
            BookingRequestApplyView(booking: self.bookingRequest)
        }
        .routable(self)
    }

    func handleRoute(_ route: Route) {
        switch route {
        case .bookingRequests, .bookingApplications:
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
