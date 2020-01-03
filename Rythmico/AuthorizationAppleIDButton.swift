import SwiftUI
import AuthenticationServices

struct AuthorizationAppleIDButton: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            // Required to force SwiftUI to recreate the UIViewRepresentable
            // https://stackoverflow.com/a/56852456
            if colorScheme == .light {
                Representable()
            } else {
                Representable()
            }
        }
    }
}

extension AuthorizationAppleIDButton {
    struct Representable: UIViewRepresentable {
        func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
            switch context.environment.colorScheme {
            case .light:
                return ASAuthorizationAppleIDButton(type: .continue, style: .black)
            case .dark:
                return ASAuthorizationAppleIDButton(type: .continue, style: .white)
            @unknown default:
                return ASAuthorizationAppleIDButton(type: .continue, style: .black)
            }
        }

        func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    }
}
