#if canImport(AuthenticationServices)
import SwiftUI
import AuthenticationServices

public struct AppleIDAuthButton: View {
    private enum Const {
        static let maxWidth: CGFloat = .grid(.max)
        static let regularHeight: CGFloat = 48
    }

    @Environment(\.colorScheme)
    private var colorScheme
    // TODO: make `RythmicoButton` heights adaptable
//    @ScaledMetric(relativeTo: .largeTitle)
    private var height = Const.regularHeight

    public var type: SignInWithAppleButton.Label
    public var action: () -> Void

    public init(type: SignInWithAppleButton.Label = .continue, action: @escaping () -> Void) {
        self.type = type
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            SignInWithAppleButton(type, onRequest: { _ in }, onCompletion: { _ in })
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .cornerRadius(4)
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
                AppleIDAuthButton {}
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
#endif
