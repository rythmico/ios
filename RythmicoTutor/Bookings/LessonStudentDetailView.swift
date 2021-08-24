import SwiftUIEncore
import ComposableNavigator

struct LessonStudentDetailScreen: Screen {
    let lesson: Lesson
    let presentationStyle: ScreenPresentationStyle = .push

    struct Builder: NavigationTree {
        var builder: some PathBuilder {
            Screen(
                content: { (screen: LessonStudentDetailScreen) in
                    LessonStudentDetailView(lesson: screen.lesson)
                }
            )
        }
    }
}

struct LessonStudentDetailView: View {
    let lesson: Lesson

    var name: String { lesson.student.name }
    var age: String { "\(lesson.student.age)" }
    var about: String? { lesson.student.about.isEmpty ? nil : lesson.student.about }

    var privateNote: String { lesson.privateNote.isEmpty ? "None" : lesson.privateNote }
    var privateNoteOpacity: Double { lesson.privateNote.isEmpty ? 0.5 : 1 }

    var body: some View {
        List {
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
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Student Details"), displayMode: .inline)
    }
}
