import SwiftUISugar

struct LessonDetailTutorStatusView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lesson: Lesson

    var tutor: Tutor { lesson.tutor }

    var body: some View {
        AdHocButton(action: action ?? {}) { state in
            SelectableContainer(
                fill: .rythmico.background,
                isSelected: state == .pressed
            ) { state in
                InlineContentTitleSubtitleView(
                    content: { avatar(backgroundColor: state.backgroundColor) },
                    title: title,
                    subtitle: subtitle
                )
                .padding(.grid(5))
            }
        }
        .disabled(action == nil)
    }

    @ViewBuilder
    func avatar(backgroundColor: Color) -> some View {
        TutorAvatarView(tutor, mode: .original)
            .frame(maxWidth: .grid(14), maxHeight: .grid(14))
            .withSmallDBSCheck()
    }

    var title: String {
        tutor.name
    }

    var subtitle: String? {
        nil
    }

    var action: Action? {
        guard let lessonPlan = Current.lessonPlanRepository.firstById(lesson.lessonPlanId) else {
            return nil
        }
        return {
            navigator.go(
                to: LessonPlanTutorDetailScreen(lessonPlan: lessonPlan, tutor: tutor),
                on: currentScreen
            )
        }
    }
}

#if DEBUG
struct LessonDetailTutorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailTutorStatusView(lesson: .scheduledStub)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif