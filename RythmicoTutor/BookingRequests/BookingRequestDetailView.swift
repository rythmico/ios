import SwiftUI

struct BookingRequestDetailView: View {
    private let bookingRequest: BookingRequest

    private let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private let timeFormatter = Current.dateFormatter(format: .time(.short))

    init(bookingRequest: BookingRequest) {
        self.bookingRequest = bookingRequest
    }

    func openMap() {
        var appleMapsURLComponents = URLComponents()
        appleMapsURLComponents.scheme = "https"
        appleMapsURLComponents.host = "maps.apple.com"
        appleMapsURLComponents.queryItems = [URLQueryItem(name: "q", value: bookingRequest.postcode)]
        guard let appleMapsURL = appleMapsURLComponents.url else {
            return
        }
        Current.urlOpener.open(appleMapsURL)
    }

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section(header: Text("REQUEST DETAILS")) {
                    TitleCell(title: "Submitted by", detail: bookingRequest.submitterName)
                }
                Section(header: Text("LESSON SCHEDULE DETAILS")) {
                    TitleCell(title: "Start Date", detail: dateFormatter.string(from: bookingRequest.schedule.startDate))
                    TitleCell(title: "Time", detail: timeFormatter.string(from: bookingRequest.schedule.startDate))
                    TitleCell(title: "Duration", detail: "\(bookingRequest.schedule.duration) minutes")
                }
                Section(header: Text("STUDENT DETAILS")) {
                    TitleCell(title: "Name", detail: bookingRequest.student.name)
                    TitleCell(title: "Age", detail: "\(bookingRequest.student.age)")
                    TitleCell(title: "Gender", detail: bookingRequest.student.gender.name)
                    if hasAbout {
                        VStack(alignment: .leading, spacing: .spacingUnit) {
                            Text("About")
                                .foregroundColor(.primary)
                                .font(.body)
                            Text(bookingRequest.student.about)
                                .foregroundColor(.secondary)
                                .font(.body)
                        }
                        .padding(.vertical, .spacingUnit)
                    }
                }
                Section(header: Text("PRIVATE NOTE")) {
                    Text(hasPrivateNote ? bookingRequest.privateNote : "None")
                        .foregroundColor(Color.secondary.opacity(hasPrivateNote ? 1 : 0.5))
                        .font(.body)
                        .padding(.vertical, .spacingUnit)
                }
                Section(
                    header: Text("ADDRESS DETAILS"),
                    footer: Text("Exact location and address will be provided if you're selected.")
                ) {
                    VStack(alignment: .leading, spacing: .spacingExtraSmall) {
                        MapView()
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: .spacingUnit * 2, style: .continuous))
                            .onTapGesture(perform: openMap)
                        Text(bookingRequest.postcode)
                            .foregroundColor(.primary)
                            .font(.body)
                    }
                    .padding(.vertical, .spacingUnit * 2)
                }
            }
            .listStyle(GroupedListStyle())

            FloatingView {
                Button("Apply", action: {}).primaryStyle()
            }
        }
        .navigationBarTitle(Text(title), displayMode: .inline)
    }

    private var title: String { "\(bookingRequest.student.name) - \(bookingRequest.instrument.name) Request" }
    private var hasAbout: Bool { !bookingRequest.student.about.isEmpty }
    private var hasPrivateNote: Bool { !bookingRequest.privateNote.isEmpty }
}

#if DEBUG
struct BookingRequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestDetailView(bookingRequest: .stub)
    }
}
#endif
