import SwiftUIEncore
import ComposableNavigator

struct LessonDetailScreen: Screen {
    let lesson: Lesson
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonDetailScreen) in
                    LessonDetailView(lesson: screen.lesson)
                },
                nesting: {
                    LessonStudentDetailScreen.Builder()
                }
            )
        }
    }
}

struct LessonDetailView: View {
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    let lesson: Lesson

    private static let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private static let timeFormatter = Current.dateFormatter(format: .preset(time: .short))

    var studentName: String { lesson.student.name }
    var startDate: String { Self.dateFormatter.string(from: lesson.schedule.startDate) }
    var time: String { Self.timeFormatter.string(from: lesson.schedule.startDate) }
    var duration: String { lesson.schedule.duration.title }

    private func presentStudentDetails() {
        navigator.go(to: LessonStudentDetailScreen(lesson: lesson), on: currentScreen)
    }

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
                // TODO: upcoming
//                AddressMapCell(addressInfo: .address(lesson.address))
            }
            Section {
                GroupedButton(title: "View Student Details", action: presentStudentDetails)
                GroupedButton(title: "Contact", action: presentContactSheet)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(lesson.title), displayMode: .inline)
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
