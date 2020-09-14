import SwiftUI

extension LessonPlanCancellationView {
    struct LoadingView: View {
        var body: some View {
            ZStack {
                Color(.systemBackground)
                HStack(spacing: .spacingExtraSmall) {
                    ActivityIndicator(color: .rythmicoGray90)
                    Text("Cancelling plan...")
                        .rythmicoFont(.subheadlineBold)
                        .foregroundColor(.rythmicoForeground)
                }
            }
        }
    }
}
