import SwiftUI
import Sugar

struct FloatingInputView<Content: View>: View {
    var doneAction: () -> Void
    var content: Content

    init(
        doneAction: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.doneAction = doneAction
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Spacer()
                Button(action: doneAction) {
                    Text("Done")
                        .rythmicoFont(.callout)
                        .foregroundColor(.rythmicoPurple)
                }
                .padding(.horizontal, .spacingMedium)
                .padding(.top, .spacingExtraSmall)
            }
            content
        }
        .background(Color.systemLightGray.edgesIgnoringSafeArea(.bottom))
        .transition(
            AnyTransition
                .move(edge: .bottom)
                .combined(with: .offset(y: UIApplication.shared.windows[0].safeAreaInsets.bottom)) // TODO: remove when SwiftUI respects edgesIgnoringSafeArea.
        )
        .onAppear(perform: UIApplication.shared.dismissKeyboard)
    }
}
