import SwiftUIEncore

struct FloatingView<Content: View>: View {
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: 0) {
            HDivider()
            content
                .frame(maxWidth: .grid(.max), alignment: .center)
                .padding(.vertical, .grid(3))
                .padding(.horizontal, .grid(5))
        }
        .transition(.move(edgeWithSafeArea: .bottom))
    }
}
