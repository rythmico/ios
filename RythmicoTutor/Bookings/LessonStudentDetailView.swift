import SwiftUI

struct LessonStudentDetailView: View {
    var lesson: Lesson

    var name: String { lesson.student.name }
    var age: String { "\(lesson.student.age)" }
    var gender: String { lesson.student.gender.name }
    var about: String? { lesson.student.about.isEmpty ? nil : lesson.student.about }

    var privateNote: String { lesson.privateNote.isEmpty ? "None" : lesson.privateNote }
    var privateNoteOpacity: Double { lesson.privateNote.isEmpty ? 0.5 : 1 }

    var body: some View {
        List {
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
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Student Details"), displayMode: .inline)
    }
}
