import SwiftUIEncore

struct OnboardingView: View, TestableView {
    @StateObject
    var coordinator = Current.siwaCoordinator()
    var isLoading: Bool { coordinator.isLoading }
    var isSIWAButtonEnabled: Bool { !isLoading }

    @State
    var authorizationErrorMessage: String?

    var instructionalViewContent: (content: InstructionalViewContent, animated: Bool) {
        let legacySIWAUserID = Current.keychain.legacySIWAAuthorizationUserID
        let newSIWAUserInfo = Current.keychain.siwaUserInfo
        switch (legacySIWAUserID, newSIWAUserInfo) {
        case (.none, .none):
            return (content: .welcome, animated: true)
        case (.none, .some),
             (.some, .none),
             (.some, .some):
            return (content: .loggedOut, animated: false)
        }
    }

    let inspection = SelfInspection()
    var body: some View {
        InstructionalView(instructionalViewContent.content, animated: instructionalViewContent.animated) {
            AppleIDAuthButton(action: authenticateWithApple)
                .accessibility(hint: Text("Double tap to sign in with your Apple ID"))
                .disabled(!isSIWAButtonEnabled)
                .opacity(isSIWAButtonEnabled ? 1 : 0)
                .overlay(Group {
                    if isLoading {
                        ActivityIndicator(color: .rythmico.foreground)
                    }
                })
        }
        .backgroundColor(.rythmico.background)
        .allowsHitTesting(!isLoading)
        .animation(.rythmicoSpring(duration: .durationMedium), value: isLoading)
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
