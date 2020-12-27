import SwiftUI

struct LessonPlanBookingPolicyView: View {
    var asset: ImageAsset
    var title: String
    var description: String

    var body: some View {
        HStack(spacing: .spacingExtraSmall) {
            Image(decorative: asset.name)
                .renderingMode(.template)
                .foregroundColor(.rythmicoPurple)
            VStack(alignment: .leading, spacing: .spacingUnit / 2) {
                Text(title)
                    .rythmicoFont(.calloutBold)
                    .foregroundColor(.rythmicoForeground)
                Text(description)
                    .rythmicoFont(.callout)
                    .foregroundColor(.rythmicoGray90)
                    .lineSpacing(.spacingUnit / 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.spacingExtraSmall)
        .modifier(RoundedShadowContainer())
    }
}

extension LessonPlanBookingPolicyView {
    static var skipLessons: Self {
        Self(
            asset: Asset.iconPolicySkipLessons,
            title: "Skip Lessons",
            description: "Skip lessons for free. Up until 3 hours before the scheduled start time."
        )
    }

    static var cancelAnytime: Self {
        Self(
            asset: Asset.iconPolicyCancelAnytime,
            title: "Cancel anytime",
            description: "Easy cancellation. Free up until 3 hours before an upcoming lesson starts."
        )
    }

    static var trustedTutors: Self {
        Self(
            asset: Asset.iconPolicyChildSafety,
            title: "Trusted Tutors",
            description: "All tutors are DBS checked with years of experience working with children."
        )
    }
}

#if DEBUG
struct LessonPlanBookingPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LessonPlanBookingPolicyView.skipLessons
            LessonPlanBookingPolicyView.cancelAnytime
            LessonPlanBookingPolicyView.trustedTutors
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
