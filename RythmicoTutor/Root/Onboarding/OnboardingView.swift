import SwiftUIEncore

struct OnboardingView: View, TestableView {
    @State
    var isLoading: Bool = false
    var isAppleAuthorizationButtonEnabled: Bool { !isLoading }

    @State
    var errorMessage: String?

    func dismissError() { errorMessage = nil }

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
                        .disabled(!isAppleAuthorizationButtonEnabled)
                }
            }
            .padding(.grid(6))
            .animation(.rythmicoSpring(duration: .durationMedium), value: isLoading)
        }
        .onDisappear {
            Current.voiceOver.announce("Welcome")
        }
        .testable(self)
        .onAppear(perform: Current.deviceUnregisterCoordinator.unregisterDevice)
        .multiModal {
            $0.alert(error: errorMessage, dismiss: dismissError)
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
