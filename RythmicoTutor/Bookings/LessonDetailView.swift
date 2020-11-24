import SwiftUI
import SwiftUIMapView

struct LessonDetailView: View {
    var lesson: Lesson

    private let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private let timeFormatter = Current.dateFormatter(format: .time(.short))

    var title: String {
        [lesson.student.name.firstWord, "\(lesson.instrument.name) Lesson \(lesson.number)"]
            .compact()
            .joined(separator: " - ")
    }
    var studentName: String { lesson.student.name }
    var startDate: String { dateFormatter.string(from: lesson.schedule.startDate) }
    var time: String { timeFormatter.string(from: lesson.schedule.startDate) }
    var duration: String { "\(lesson.schedule.duration) minutes" }

    @State
    private var isStudentDetailsPresented = false
    private func presentStudentDetails() { isStudentDetailsPresented = true }

    @State
    private var isContactSheetPresented = false
    private func presentContactSheet() { isContactSheetPresented = true }
    @State
    private var error: Error?

    var body: some View {
        List {
            Section(header: Text("LESSON DETAILS")) {
                TitleCell(title: "Student", detail: studentName)
                TitleCell(title: "Start Date", detail: startDate)
                TitleCell(title: "Time", detail: time)
                TitleCell(title: "Duration", detail: duration)
            }
            Section(header: Text("ADDRESS DETAILS")) {
                AddressMapCell(addressInfo: .address(lesson.address))
            }
            Section {
                GroupedButton("View Student Details", action: presentStudentDetails).navigationLink(
                    NavigationLink(
                        destination: Text(""), // TODO
                        isActive: $isStudentDetailsPresented,
                        label: { EmptyView() }
                    )
                )
                GroupedButton("Contact", action: presentContactSheet)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(title), displayMode: .inline)
        .phoneNumberOpeningSheet(
            isPresented: $isContactSheetPresented,
            phoneNumber: lesson.phoneNumber,
            error: $error
        )
    }
}

#if DEBUG
struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(lesson: .scheduledStub)
    }
}
#endif
