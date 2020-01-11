import SwiftUI
import AuthenticationServices

struct AppleAuthorizationButton: View {
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
    }
}

extension AppleAuthorizationButton {
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

struct AppleAuthorizationButton_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack {
                ForEach(ColorScheme.allCases, id: \.self) {
                    AppleAuthorizationButton()
                        .environment(\.colorScheme, $0)
                        .frame(height: 44)
                        .padding()
                }
            }
        }
    }
}
