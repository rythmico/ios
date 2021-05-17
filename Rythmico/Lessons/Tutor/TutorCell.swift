import SwiftUI

struct TutorCell: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.currentScreen) private var currentScreen

    private enum Const {
        static let avatarSize = .spacingUnit * 14
    }

    var lessonPlan: LessonPlan
    var tutor: Tutor

    var body: some View {
        Button(action: openTutorPorfolio) {
            HStack(spacing: .spacingExtraSmall) {
                TutorAvatarView(tutor, mode: .original)
                    .frame(width: Const.avatarSize, height: Const.avatarSize)
                    .withSmallDBSCheck()
                Text(tutor.name)
                    .rythmicoTextStyle(.subheadlineBold)
                    .foregroundColor(.rythmicoForeground)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(.spacingMedium)
            .frame(maxWidth: .spacingMax, alignment: .leading)
        }
        .modifier(RoundedShadowContainer())
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
