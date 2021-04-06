import SwiftUI
import AuthenticationServices

struct AuthorizationAppleIDButton: View {
    private enum Const {
        static let maxWidth: CGFloat = 320
        static let regularHeight: CGFloat = 44
    }

    @Environment(\.colorScheme)
    private var colorScheme
    @ScaledMetric(relativeTo: .largeTitle)
    private var height = Const.regularHeight

    var type: SignInWithAppleButton.Label = .continue
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            SignInWithAppleButton(type, onRequest: { _ in }, onCompletion: { _ in })
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: Const.maxWidth)
        .frame(height: height)
    }
}

#if DEBUG
struct AuthorizationAppleIDButton_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            ZStack {
                Color.blue
                AuthorizationAppleIDButton {}
                    .environment(\.colorScheme, colorScheme)
                    .environment(\.sizeCategory, .extraSmall)
//                    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            }
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
