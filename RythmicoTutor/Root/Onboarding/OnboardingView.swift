import SwiftUIEncore

struct OnboardingView: View, TestableView {
    @StateObject
    var coordinator = Current.siwaCoordinator()
    var isLoading: Bool { coordinator.isLoading }
    var isSIWAButtonEnabled: Bool { !isLoading }

    @State
    var authorizationErrorMessage: String?

    let inspection = SelfInspection()
    var body: some View {
        ZStack {
            AppSplash(image: App.logo, title: App.name)
            VStack(spacing: 0) {
                Spacer()
                if isLoading {
                    ActivityIndicator()
                        .frame(width: 44, height: 44)
                } else {
                    AppleIDAuthButton(action: authenticateWithApple)
                        .accessibility(hint: Text("Double tap to sign in with your Apple ID"))
                        .disabled(!isSIWAButtonEnabled)
                }
            }
            .padding(.grid(6))
            .animation(.rythmicoSpring(duration: .durationMedium), value: isLoading)
        }
        .onDisappear {
            Current.voiceOver.announce("Welcome")
        }
        .testable(self)
        .onSuccess(coordinator, perform: handleAuthenticationSuccess)
        .multiModal {
            $0.alertOnFailure(coordinator, onDismiss: coordinator.dismissFailure)
            $0.alert(error: $authorizationErrorMessage)
        }
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
