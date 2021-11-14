import SwiftUIEncore

struct LessonDetailTutorBoxView: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    let lesson: Lesson

    var tutor: Tutor { lesson.tutor }

    var body: some View {
        SectionHeaderContentView("Tutor", style: .box) {
            CustomButton(action: action) { state in
                SelectableContainer(
                    fill: .rythmico.background,
                    isSelected: state == .pressed
                ) { state in
                    InlineContentTitleSubtitleView(
                        content: avatar,
                        title: title,
                        subtitle: subtitle
                    )
                    .padding(.grid(5))
                }
            }
        }
    }

    @ViewBuilder
    func avatar() -> some View {
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

    var action: Action {
        { navigator.go(to: LessonPlanTutorDetailScreen(tutor: tutor), on: currentScreen) }
    }
}

#if DEBUG
struct LessonDetailTutorBoxView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailTutorBoxView(lesson: .scheduledStub)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
