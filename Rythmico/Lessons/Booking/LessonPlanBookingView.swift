import SwiftUI

struct LessonPlanBookingView: View {
    var lessonPlan: LessonPlan
    var application: LessonPlan.Application

    var title: String {
        ["Book", application.tutor.name.firstWord].compact().spaced()
    }

    var subtitle: [MultiStyleText.Part] {
        ["Review the proposed lesson plan and price per lesson before booking".part]
    }

    var body: some View {
        VStack(spacing: .spacingExtraLarge) {
            TitleSubtitleContentView(title: title, subtitle: subtitle) {
                Group {
                    SectionHeaderView(title: "Lesson Schedule")
                    ScheduleDetailsView(lessonPlan.schedule, tutor: application.tutor)
                }
                .padding(.horizontal, .spacingMedium)
            }
        }
    }
}

struct LessonPlanBookingView_Previews: PreviewProvider {
    static var previews: some View {
        LessonPlanBookingView(lessonPlan: .davidGuitarPlanStub, application: .davidStub)
//            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
