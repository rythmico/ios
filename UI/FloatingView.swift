import SwiftUI
import Sugar

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
        .transition(
            AnyTransition
                .move(edge: .bottom)
                .combined(with: .offset(y: UIApplication.shared.windows[0].safeAreaInsets.bottom)) // TODO: remove when SwiftUI respects edgesIgnoringSafeArea.
        )
    }
}
