import SwiftUISugar

struct OnboardingView: View, TestableView {
    @State
    var isLoading: Bool = false
    var isAppleAuthorizationButtonEnabled: Bool { !isLoading }

    @State
    var errorMessage: String?

    func dismissError() { errorMessage = nil }

    let inspection = SelfInspection()
    var body: some View {
        InstructionalView(animated: true) {
            AppleIDAuthButton(action: authenticateWithApple)
                .accessibility(hint: Text("Double tap to sign in with your Apple ID"))
                .disabled(!isAppleAuthorizationButtonEnabled)
                .opacity(isAppleAuthorizationButtonEnabled ? 1 : 0)
                .overlay(Group {
                    if isLoading {
                        ActivityIndicator(color: .rythmico.foreground)
                    }
                })
        }
        .backgroundColor(.rythmico.background)
        .allowsHitTesting(!isLoading)
        .animation(.rythmicoSpring(duration: .durationMedium), value: isLoading)
        .alert(error: errorMessage, dismiss: dismissError)
        .onDisappear {
            Current.voiceOver.announce("Welcome")
        }
        .testable(self)
        .onAppear(perform: Current.deviceUnregisterCoordinator.unregisterDevice)
    }
}

#if DEBUG
struct OnboardingView_Preview: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environment(\.colorScheme, .light)
        OnboardingView()
            .environment(\.colorScheme, .dark)
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
#endif
