import SwiftUI

struct LessonPlanApplicationDetailHeaderView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    var body: some View {
        HStack(spacing: .spacingSmall) {
            LessonPlanTutorAvatarView(application.tutor, mode: .original)
                .frame(width: .spacingUnit * 20, height: .spacingUnit * 20)
            VStack(alignment: .leading, spacing: .spacingUnit) {
                Text(application.tutor.name)
                    .rythmicoFont(.largeTitle)
                    .foregroundColor(.rythmicoForeground)
                Text(lessonPlan.instrument.name + " Tutor")
                    .rythmicoFont(.callout)
                    .foregroundColor(.rythmicoGray90)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .padding(.horizontal, .spacingMedium)
    }
}

#if DEBUG
struct LessonPlanApplicationDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanApplicationDetailHeaderView(
            lessonPlan: .pendingJackGuitarPlanStub,
            application: .davidStub
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
