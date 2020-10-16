import SwiftUI

struct LessonPlanConfirmationDetailsView: View {
    var lessonPlan: LessonPlan
    var tutor: LessonPlan.Tutor

    var body: some View {
        VStack(spacing: .spacingSmall) {
            HStack(alignment: .firstTextBaseline, spacing: .spacingExtraSmall) {
                VectorImage(asset: Asset.iconInfo)
                    .alignmentGuide(.firstTextBaseline) { $0[.bottom] - .spacingUnit / 2 }
                    .accentColor(.rythmicoGray90)
                MultiStyleText(
                    parts: [
                        "First Lesson: ".color(.rythmicoGray90),
                        dateFormatter.string(from: lessonPlan.schedule.startDate).color(.rythmicoGray90).style(.bodyBold),
                        " (\(relativeDateFormatter.localizedString(for: lessonPlan.schedule.startDate, relativeTo: Current.date())))".color(.rythmicoGray90)
                    ],
                    expanded: false
                )
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            }
            HStack(spacing: .spacingExtraSmall) {
                LessonPlanTutorAvatarView(tutor, mode: .thumbnail)
                    .fixedSize()
                Text(tutor.name)
                    .foregroundColor(.rythmicoGray90)
                    .rythmicoFont(.bodyBold)
            }
        }
    }

    private let dateFormatter = Current.dateFormatter(format: .custom("d MMMM"))
    private let relativeDateFormatter = Current.relativeDateTimeFormatter(context: .standalone, style: .full, precise: false)
}
