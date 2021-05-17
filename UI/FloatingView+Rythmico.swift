import SwiftUI
import FoundationSugar

struct FloatingView<Content: View>: View {
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            content
                .frame(maxWidth: .spacingMax, alignment: .center)
                .padding(.vertical, .spacingExtraSmall)
                .padding(.horizontal, .spacingMedium)
        }
        .background(Color.rythmicoBackgroundSecondary.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edgeWithSafeArea: .bottom))
    }
}
