import SwiftUI
import AuthenticationServices

struct AuthorizationAppleIDButton: View {
    private enum Const {
        static let maxWidth: CGFloat = 320
        static let defaultHeight: CGFloat = 44
    }

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.sizeCategory) private var sizeCategory

    var type: ASAuthorizationAppleIDButton.ButtonType = .continue

    var body: some View {
        Group {
            // Required to force SwiftUI to recreate the UIViewRepresentable
            // https://stackoverflow.com/a/56852456
            if colorScheme == .light {
                Representable(type: type)
            } else {
                Representable(type: type)
            }
        }
        .frame(maxWidth: Const.maxWidth)
        .frame(height: Const.defaultHeight * sizeCategory.sizeFactor)
    }
}

extension AuthorizationAppleIDButton {
    private struct Representable: UIViewRepresentable {
        var type: ASAuthorizationAppleIDButton.ButtonType

        func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
            switch context.environment.colorScheme {
            case .light:
                return ASAuthorizationAppleIDButton(type: type, style: .black)
            case .dark:
                return ASAuthorizationAppleIDButton(type: type, style: .white)
            @unknown default:
                return ASAuthorizationAppleIDButton(type: type, style: .black)
            }
        }

        func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    }
}

#if DEBUG
struct AuthorizationAppleIDButton_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack {
                ForEach(ColorScheme.allCases, id: \.self) {
                    AuthorizationAppleIDButton()
                        .environment(\.colorScheme, $0)
                        .environment(\.sizeCategory, .extraSmall)
//                        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
                        .padding()
                }
            }
        }
    }
}
#endif
