import SwiftUI

struct RequestLessonPlanLoadingView: View {
    var body: some View {
        HStack(spacing: .spacingExtraSmall) {
            ActivityIndicator(style: .medium, color: .rythmicoForeground)
            Text("Submitting proposal...").rythmicoFont(.subheadline).foregroundColor(.rythmicoForeground)
        }
    }
}

struct RequestLessonPlanLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        RequestLessonPlanLoadingView()
    }
}
