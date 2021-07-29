import SwiftUISugar

struct TutorCell: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    private enum Const {
        static let avatarSize: CGFloat = .grid(14)
    }

    var lessonPlan: LessonPlan
    var tutor: Tutor

    var body: some View {
        Container(style: .outline()) {
            Button(action: openTutorPorfolio) {
                HStack(spacing: .grid(3)) {
                    TutorAvatarView(tutor, mode: .original)
                        .frame(width: Const.avatarSize, height: Const.avatarSize)
                        .withSmallDBSCheck()
                    Text(tutor.name)
                        .rythmicoTextStyle(.subheadlineBold)
                        .foregroundColor(.rythmico.foreground)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .padding(.grid(5))
                .frame(maxWidth: .grid(.max), alignment: .leading)
            }
        }
    }

    private func openTutorPorfolio() {
        navigator.go(to: LessonPlanTutorDetailScreen(lessonPlan: lessonPlan, tutor: tutor), on: currentScreen)
    }
}

#if DEBUG
struct TutorCell_Previews: PreviewProvider {
    static var previews: some View {
        TutorCell(lessonPlan: .activeJackGuitarPlanStub, tutor: .jesseStub)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
