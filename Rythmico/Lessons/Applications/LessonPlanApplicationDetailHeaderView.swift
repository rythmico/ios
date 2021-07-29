import SwiftUI

struct LessonPlanApplicationDetailHeaderView: View {
    var lessonPlan: LessonPlan
    var tutor: Tutor

    var body: some View {
        HStack(spacing: .grid(4)) {
            TutorAvatarView(tutor, mode: .original)
                .frame(width: .grid(20), height: .grid(20))
                .withDBSCheck()
            VStack(alignment: .leading, spacing: .grid(1)) {
                Text(tutor.name)
                    .rythmicoTextStyle(.largeTitle)
                    .foregroundColor(.rythmico.foreground)
                Text(lessonPlan.instrument.assimilatedName + " Tutor")
                    .rythmicoTextStyle(.callout)
                    .foregroundColor(.rythmico.foreground)
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(.horizontal, .grid(5))
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
