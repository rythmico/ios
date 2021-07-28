import SwiftUI

struct LessonPlanApplicationDetailMessageView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    var body: some View {
        ScrollView {
            VStack(spacing: .grid(5)) {
                VStack(spacing: .grid(4)) {
                    if let privateNote = privateNote {
                        Text(privateNoteHeader)
                            .rythmicoTextStyle(.subheadlineBold)
                            .foregroundColor(.rythmico.foreground)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(privateNote)
                            .rythmicoTextStyle(.body)
                            .foregroundColor(.rythmico.gray90)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("No private message from \(application.tutor.name).")
                            .rythmicoTextStyle(.body)
                            .foregroundColor(.rythmico.gray30)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .grid(.max))
                .padding(.horizontal, .grid(5))

                Divider().overlay(Color.rythmico.gray20)

                VStack(spacing: .grid(4)) {
                    HStack(spacing: .grid(4)) {
                        Text("Lesson Schedule")
                            .rythmicoTextStyle(.subheadlineBold)
                            .foregroundColor(.rythmico.foreground)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)

                        TutorAcceptedStatusPill()
                    }

                    LessonPlanRequestedScheduleView(lessonPlan.schedule, tutor: nil)
                }
                .frame(maxWidth: .grid(.max))
                .padding(.horizontal, .grid(5))
            }
            .padding(.vertical, .grid(5))
        }
    }

    private var privateNoteHeader: String {
        application.tutor.name.firstWord.map { "Private Message from \($0)" } ?? "Private Message"
    }

    private var privateNote: String? {
        application.privateNote.nilIfEmpty.map { $0.smartQuoted() }
    }
}
