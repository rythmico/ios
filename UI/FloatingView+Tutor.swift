import FoundationSugar
import SwiftUISugar

struct FloatingView<Content: View>: View {
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            content.padding(.grid(4))
        }
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.bottom))
        .transition(.move(edgeWithSafeArea: .bottom))
    }
}
