import SwiftUI
import FoundationSugar

struct FloatingInputView<Content: View>: View {
    var doneAction: () -> Void
    @ViewBuilder
    var content: Content

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Spacer()
                Button(action: doneAction) {
                    Text("Done")
                        .rythmicoFont(.bodyBold)
                        .foregroundColor(.rythmicoPurple)
                }
                .padding(.horizontal, .spacingMedium)
                .padding(.top, .spacingExtraSmall)
            }
            content
        }
        .background(Color.systemTooltipGray.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edgeWithSafeArea: .bottom))
    }
}
