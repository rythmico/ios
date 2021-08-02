import SwiftUI

struct LessonSummaryTutorStatusView: View {
    let lesson: Lesson

    var tutor: Tutor { lesson.tutor }

    var body: some View {
        HStack(spacing: .grid(3)) {
            avatar.fixedSize()
            Text(title)
                .rythmicoTextStyle(.body)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    var avatar: some View {
        TutorAvatarView(tutor, mode: .thumbnail)
    }

    var title: String {
        tutor.shortName ?? .empty
    }
}

#if DEBUG
struct LessonTutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonSummaryTutorStatusView(lesson: .scheduledStub)
                .previewDisplayName("Scheduled - Cell")
            LessonSummaryTutorStatusView(lesson: .skippedStub)
                .previewDisplayName("Skipped - Cell")
            LessonSummaryTutorStatusView(lesson: .completedStub)
                .previewDisplayName("Completed - Cell")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
