import SwiftUISugar

struct FloatingView<Content: View>: View {
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            content
                .frame(maxWidth: .grid(.max), alignment: .center)
                .padding(.vertical, .grid(3))
                .padding(.horizontal, .grid(5))
        }
        .background(Color.rythmico.backgroundSecondary.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edgeWithSafeArea: .bottom))
    }
}
