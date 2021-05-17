import SwiftUI

struct LessonPlanApplicationDetailHeaderView: View {
    var lessonPlan: LessonPlan
    var tutor: Tutor

    var body: some View {
        HStack(spacing: .spacingSmall) {
            TutorAvatarView(tutor, mode: .original)
                .frame(width: .spacingUnit * 20, height: .spacingUnit * 20)
                .withDBSCheck()
            VStack(alignment: .leading, spacing: .spacingUnit) {
                Text(tutor.name)
                    .rythmicoTextStyle(.largeTitle)
                    .foregroundColor(.rythmicoForeground)
                Text(lessonPlan.instrument.assimilatedName + " Tutor")
                    .rythmicoTextStyle(.callout)
                    .foregroundColor(.rythmicoGray90)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(.horizontal, .spacingMedium)
    }
}

#if DEBUG
struct LessonPlanApplicationDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanApplicationDetailHeaderView(
            lessonPlan: .pendingJackGuitarPlanStub,
            tutor: .davidStub
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
