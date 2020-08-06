import SwiftUI

struct BookingRequestDetailView: View {
    private let bookingRequest: BookingRequest

    private let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private let timeFormatter = Current.dateFormatter(format: .time(.short))

    init(bookingRequest: BookingRequest) {
        self.bookingRequest = bookingRequest
    }

    var body: some View {
        List {
            Section(header: Text("LESSON DETAILS")) {
                TitleCell(title: "Student", detail: bookingRequest.student.name)
                TitleCell(title: "Date", detail: dateFormatter.string(from: bookingRequest.schedule.startDate))
                TitleCell(title: "Time", detail: timeFormatter.string(from: bookingRequest.schedule.startDate))
                TitleCell(title: "Duration", detail: "\(bookingRequest.schedule.duration) minutes")
            }
        }
        .listStyle(GroupedListStyle())
//        .animation(.rythmicoSpring(duration: .durationShort, type: .damping), value: isLoading)
//        .onAppear(perform: coordinator.run)
//        .onSuccess(coordinator, perform: repository.setItems)
//        .alertOnFailure(coordinator)
    }
}

#if DEBUG
struct BookingRequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingRequestDetailView(bookingRequest: .stub)
    }
}
#endif
