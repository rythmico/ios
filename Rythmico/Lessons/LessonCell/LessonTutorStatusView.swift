import SwiftUI

extension InlineContentAndTitleView where Content == AnyView {
    init(lesson: Lesson, summarized: Bool) {
        self.init(
            content: { AnyView(lesson.avatar) },
            title: summarized ? lesson.summarizedTitle : lesson.title,
            bold: false
        )
    }
}

private extension Lesson {
    @ViewBuilder
    var avatar: some View {
        TutorAvatarView(tutor, mode: .thumbnail)
    }

    var summarizedTitle: String {
        tutor.name
    }

    var title: String {
        [tutor.name, "teaching", student.name.firstWord].compact().spaced()
    }
}

#if DEBUG
struct LessonTutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InlineContentAndTitleView(lesson: .scheduledStub, summarized: true)
                .previewDisplayName("Scheduled - Cell")
            InlineContentAndTitleView(lesson: .cancelledStub, summarized: true)
                .previewDisplayName("Cancelled - Cell")
            InlineContentAndTitleView(lesson: .completedStub, summarized: true)
                .previewDisplayName("Completed - Cell")

            InlineContentAndTitleView(lesson: .scheduledStub, summarized: false)
                .previewDisplayName("Scheduled - Detail")
            InlineContentAndTitleView(lesson: .cancelledStub, summarized: false)
                .previewDisplayName("Cancelled - Detail")
            InlineContentAndTitleView(lesson: .completedStub, summarized: false)
                .previewDisplayName("Completed - Detail")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
