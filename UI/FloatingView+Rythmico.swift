import SwiftUI
import FoundationSugar

struct FloatingView<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            content
                .padding(.vertical, .spacingExtraSmall)
                .padding(.horizontal, .spacingMedium)
        }
        .background(Color.rythmicoBackgroundSecondary.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edgeWithSafeArea: .bottom))
    }
}
