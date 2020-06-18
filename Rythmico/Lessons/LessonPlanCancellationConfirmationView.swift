import SwiftUI

extension LessonPlanCancellationView {
    struct ConfirmationView: View {
        var body: some View {
            ZStack {
                Color(.systemBackground)
                HStack(spacing: .spacingExtraSmall) {
                    Image(decorative: Asset.iconCheckmark.name)
                        .renderingMode(.template)
                        .foregroundColor(.rythmicoPurple)
                    Text("Plan cancelled successfully")
                        .rythmicoFont(.subheadlineBold)
                        .foregroundColor(.rythmicoForeground)
                }
            }
        }
    }
}
