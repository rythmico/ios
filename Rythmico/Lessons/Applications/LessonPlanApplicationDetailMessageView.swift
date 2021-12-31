import SwiftUI

struct LessonPlanApplicationDetailMessageView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    var body: some View {
        ScrollView {
            VStack(spacing: .grid(5)) {
                HeadlineContentView(privateNoteHeader) { padding in
                    Text(privateNote ?? privateNotePlaceholder)
                        .rythmicoTextStyle(.body)
                        .foregroundColor(privateNoteForegroundColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(padding)
                }
                .frame(maxWidth: .grid(.max))

                SectionHeaderContentView("Plan Details", style: .box, accessory: TutorAcceptedStatusPill.init) {
                    VStack(alignment: .leading, spacing: .grid(2)) {
                        // TODO: upcoming
//                        LessonPlanRequestedScheduleAndTutorView(schedule: lessonPlan.schedule, tutor: nil)
                        AddressLabel(address: lessonPlan.address)
                    }
                }
                .frame(maxWidth: .grid(.max))
                .padding(.horizontal, .grid(4))
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

    private var privateNotePlaceholder: String {
        "No private message from \(application.tutor.name)."
    }

    private var privateNoteForegroundColor: Color {
        privateNote != nil ? .rythmico.foreground : .rythmico.textPlaceholder
    }
}
