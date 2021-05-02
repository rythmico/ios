import SwiftUI

struct LessonPlanApplicationDetailMessageView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    var body: some View {
        ScrollView {
            VStack(spacing: .spacingMedium) {
                VStack(spacing: .spacingSmall) {
                    if let privateNote = privateNote {
                        Text(privateNoteHeader)
                            .rythmicoTextStyle(.subheadlineBold)
                            .foregroundColor(.rythmicoForeground)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(privateNote)
                            .rythmicoTextStyle(.body)
                            .foregroundColor(.rythmicoGray90)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("No private message from \(application.tutor.name).")
                            .rythmicoTextStyle(.body)
                            .foregroundColor(.rythmicoGray30)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .spacingMax)
                .padding(.horizontal, .spacingMedium)

                Divider().overlay(Color.rythmicoGray20)

                VStack(spacing: .spacingSmall) {
                    HStack(spacing: .spacingSmall) {
                        Text("Lesson Schedule")
                            .rythmicoTextStyle(.subheadlineBold)
                            .foregroundColor(.rythmicoForeground)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)

                        TutorAcceptedStatusPill()
                    }

                    LessonPlanRequestedScheduleView(lessonPlan.schedule, tutor: nil)
                }
                .frame(maxWidth: .spacingMax)
                .padding(.horizontal, .spacingMedium)
            }
            .padding(.vertical, .spacingMedium)
        }
    }

    private var privateNoteHeader: String {
        application.tutor.name.firstWord.map { "Private Message from \($0)" } ?? "Private Message"
    }

    private var privateNote: String? {
        application.privateNote.nilIfEmpty.map { $0.smartQuoted() }
    }
}
