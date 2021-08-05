import SwiftUISugar

struct LessonPlanBookingPolicyView: View {
    var asset: ImageAsset
    var title: String
    var description: String

    var body: some View {
        Container(style: .outline()) {
            HStack(alignment: .top, spacing: .grid(3)) {
                Image(decorative: asset.name)
                    .renderingMode(.template)
                    .foregroundColor(.rythmico.picoteeBlue)
                VStack(alignment: .leading, spacing: .grid(0.5)) {
                    Text(title)
                        .rythmicoTextStyle(.bodyBold)
                        .foregroundColor(.rythmico.picoteeBlue)
                    Text(description)
                        .rythmicoTextStyle(.callout)
                        .foregroundColor(.rythmico.foreground)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.grid(3))
        }
    }
}

extension LessonPlanBookingPolicyView {
    static var trustedTutors: Self {
        Self(
            asset: Asset.Icon.Policy.childSafety,
            title: "Trusted tutors",
            description: "All tutors are DBS checked with years of experience working with children."
        )
    }

    static func skipLessons(freeBeforePeriod: DateComponents) -> Self {
        Self(
            asset: Asset.Icon.Policy.skipLessons,
            title: "Skip lessons",
            description: "Skip lessons for free. Up until \(freeBeforePeriod.formattedString()) before the lesson start time."
        )
    }

    static var pauseLessonPlans: Self {
        Self(
            asset: Asset.Icon.Policy.pauseLessonPlans,
            title: "Pause lesson plans",
            description: "Pause your plan indefinitely, for free. Easily resume it when you're ready."
        )
    }

    static func cancelAnytime(freeBeforePeriod: DateComponents) -> Self {
        Self(
            asset: Asset.Icon.Policy.cancelAnytime,
            title: "Cancel anytime",
            description: "Easy cancellation. Free up until \(freeBeforePeriod.formattedString()) before an upcoming lesson."
        )
    }
}

#if DEBUG
struct LessonPlanBookingPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanBookingPolicyView.skipLessons(freeBeforePeriod: .init(hour: 24))
            LessonPlanBookingPolicyView.cancelAnytime(freeBeforePeriod: .init(hour: 24))
            LessonPlanBookingPolicyView.trustedTutors
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
