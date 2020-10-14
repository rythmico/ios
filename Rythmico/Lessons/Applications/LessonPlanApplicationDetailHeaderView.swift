import SwiftUI

struct LessonPlanApplicationDetailHeaderView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application
    var expanded: Bool

    @Namespace private var animation

    var body: some View {
        ZStack {
            if expanded {
                VStack(spacing: .spacingExtraSmall) {
                    LessonPlanTutorAvatarView(application.tutor, mode: .original)
                        .frame(width: .spacingUnit * 24, height: .spacingUnit * 24)
                        .matchedGeometryEffect(id: "avatar", in: animation)
                    VStack(spacing: .spacingUnit) {
                        Text(application.tutor.name)
                            .rythmicoFont(.largeTitle)
                            .foregroundColor(.rythmicoForeground)
                            .matchedGeometryEffect(id: "title", in: animation)
                        Text(lessonPlan.instrument.name + " Tutor")
                            .rythmicoFont(.callout)
                            .foregroundColor(.rythmicoGray90)
                            .matchedGeometryEffect(id: "subtitle", in: animation)
                    }
                }
            } else {
                HStack(spacing: .spacingSmall) {
                    LessonPlanTutorAvatarView(application.tutor, mode: .original)
                        .frame(width: .spacingUnit * 20, height: .spacingUnit * 20)
                        .matchedGeometryEffect(id: "avatar", in: animation)
                    VStack(alignment: .leading, spacing: .spacingUnit) {
                        Text(application.tutor.name)
                            .rythmicoFont(.largeTitle)
                            .foregroundColor(.rythmicoForeground)
                            .matchedGeometryEffect(id: "title", in: animation)
                        Text(lessonPlan.instrument.name + " Tutor")
                            .rythmicoFont(.callout)
                            .foregroundColor(.rythmicoGray90)
                            .matchedGeometryEffect(id: "subtitle", in: animation)
                    }
                }
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
        Group {
            LessonPlanApplicationDetailHeaderView(
                lessonPlan: .pendingJackGuitarPlanStub,
                application: .davidStub,
                expanded: false
            )
            LessonPlanApplicationDetailHeaderView(
                lessonPlan: .pendingJackGuitarPlanStub,
                application: .davidStub,
                expanded: true
            )
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
