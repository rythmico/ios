import ComposableNavigator
import TutorDO
import SwiftUIEncore

struct LessonPlanRequestDetailScreen: Screen {
    let lessonPlanRequest: LessonPlanRequest
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonPlanRequestDetailScreen) in
                    LessonPlanRequestDetailView(lessonPlanRequest: screen.lessonPlanRequest)
                },
                nesting: {
                    LessonPlanRequestApplyScreen.Builder()
                }
            )
        }
    }
}

struct LessonPlanRequestDetailView: View {
    @Environment(\.navigator)
    private var navigator
    @Environment(\.currentScreen)
    private var currentScreen

    var lessonPlanRequest: LessonPlanRequest

    var title: String { "\(lessonPlanRequest.student.firstName) - \(lessonPlanRequest.instrument.assimilatedName) Request" }
    var submittedBy: String { lessonPlanRequest.submitterName }
    var startDate: String { lessonPlanRequest.schedule.start.formatted(custom: "d MMMM", locale: Current.locale()) }
    var time: String { lessonPlanRequest.schedule.time.formatted(style: .short, locale: Current.locale()) }
    var duration: String { lessonPlanRequest.schedule.duration.formatted(locale: Current.locale()) }
    var name: String { lessonPlanRequest.student.firstName }
    var age: String { "\(lessonPlanRequest.student.age)" }
    var about: String? { lessonPlanRequest.student.about.isEmpty ? nil : lessonPlanRequest.student.about }
    var privateNote: String { lessonPlanRequest.privateNote.isEmpty ? "None" : lessonPlanRequest.privateNote }
    var privateNoteOpacity: Double { lessonPlanRequest.privateNote.isEmpty ? 0.5 : 1 }
    var postcode: String { lessonPlanRequest.address.formatted(style: .multiline) }

    private func presentApplicationView() {
        navigator.go(to: LessonPlanRequestApplyScreen(lessonPlanRequest: lessonPlanRequest), on: currentScreen)
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
                    AddressMapCell(source: .partialAddress(lessonPlanRequest.address))
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
struct LessonPlanRequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanRequestDetailView(lessonPlanRequest: .stub)
    }
}
#endif
