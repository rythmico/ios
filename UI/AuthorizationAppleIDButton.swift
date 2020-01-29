import SwiftUI
import AuthenticationServices

struct AuthorizationAppleIDButton: View {
    private enum Const {
        static let defaultHeight: CGFloat = 44
    }

    @Environment(\.colorScheme) private var colorScheme

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
        .frame(height: Const.defaultHeight)
    }
}

extension AuthorizationAppleIDButton {
    private struct Representable: UIViewRepresentable {
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

struct AuthorizationAppleIDButton_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack {
                ForEach(ColorScheme.allCases, id: \.self) {
                    AuthorizationAppleIDButton()
                        .environment(\.colorScheme, $0)
                        .padding()
                }
            }
        }
    }
}
