import SwiftUI

struct RequestLessonPlanLoadingView: View {
    var body: some View {
        HStack(spacing: .spacingExtraSmall) {
            ActivityIndicator(style: .medium, color: .rythmicoGray90)
            Text("Submitting proposal...")
                .rythmicoFont(.subheadline)
                .foregroundColor(.rythmicoForeground)
        }
    }
}

#if DEBUG
struct RequestLessonPlanLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanLoadingView()
    }
}
#endif
