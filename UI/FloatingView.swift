import SwiftUI
import Sugar

struct FloatingView<Content: View>: View {
    var backgroundColor: Color
    var content: Content

    init(backgroundColor: Color, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            content
                .padding(.vertical, .spacingExtraSmall)
                .padding(.horizontal, .spacingMedium)
        }
        .background(backgroundColor.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edgeWithSafeArea: .bottom))
    }
}
