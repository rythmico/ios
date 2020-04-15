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
//                .padding(.vertical, .spacingExtraSmall)
//                .padding(.horizontal, .spacingMedium)
        }
        .background(Color.systemLightGray.edgesIgnoringSafeArea(.bottom))
        .transition(.move(edge: .bottom))
        .onAppear(perform: UIApplication.shared.dismissKeyboard)
    }
}
