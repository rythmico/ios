import SwiftUI

extension InlineContentAndTitleView where Content == AnyView {
    init(lesson: Lesson) {
        self.init(content: { AnyView(lesson.avatar) }, title: lesson.summarizedTitle, bold: false)
    }
}

private extension Lesson {
    @ViewBuilder
    var avatar: some View {
        TutorAvatarView(tutor, mode: .thumbnail)
    }

    var summarizedTitle: String {
        tutor.shortName ?? .empty
    }
}

#if DEBUG
struct LessonTutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InlineContentAndTitleView(lesson: .scheduledStub)
                .previewDisplayName("Scheduled - Cell")
            InlineContentAndTitleView(lesson: .skippedStub)
                .previewDisplayName("Skipped - Cell")
            InlineContentAndTitleView(lesson: .completedStub)
                .previewDisplayName("Completed - Cell")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
