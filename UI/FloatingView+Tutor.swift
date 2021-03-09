import SwiftUI
import FoundationSugar

struct FloatingView<Content: View>: View {
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            content.padding(.spacingSmall)
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.bottom))
        .transition(.move(edgeWithSafeArea: .bottom))
    }
}
