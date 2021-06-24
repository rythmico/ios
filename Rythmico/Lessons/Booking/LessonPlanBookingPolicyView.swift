import SwiftUI
import FoundationSugar

struct LessonPlanBookingPolicyView: View {
    var asset: ImageAsset
    var title: String
    var description: String

    var body: some View {
        HStack(spacing: .grid(3)) {
            Image(decorative: asset.name)
                .renderingMode(.template)
                .foregroundColor(.rythmicoPurple)
            VStack(alignment: .leading, spacing: .grid(0.5)) {
                Text(title)
                    .rythmicoTextStyle(.calloutBold)
                    .foregroundColor(.rythmicoForeground)
                Text(description)
                    .rythmicoTextStyle(.callout)
                    .foregroundColor(.rythmicoGray90)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.grid(3))
        .modifier(RoundedShadowContainer())
    }
}

extension LessonPlanBookingPolicyView {
    static func skipLessons(freeBeforePeriod: DateComponents) -> Self {
        Self(
            asset: Asset.Icon.Policy.skipLessons,
            title: "Skip Lessons",
            description: "Skip lessons for free. Up until \(freeBeforePeriod.formattedString()) before the scheduled start time."
        )
    }

    static func cancelAnytime(freeBeforePeriod: DateComponents) -> Self {
        Self(
            asset: Asset.Icon.Policy.cancelAnytime,
            title: "Cancel anytime",
            description: "Easy cancellation. Free up until \(freeBeforePeriod.formattedString()) before an upcoming lesson starts."
        )
    }

    static var trustedTutors: Self {
        Self(
            asset: Asset.Icon.Policy.childSafety,
            title: "Trusted Tutors",
            description: "All tutors are DBS checked with years of experience working with children."
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
