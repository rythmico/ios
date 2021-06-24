import FoundationSugar
import SwiftUISugar
import MultiModal

struct OnboardingView: View, TestableView {
    @State
    var isLoading: Bool = false
    var isAppleAuthorizationButtonEnabled: Bool { !isLoading }

    @State
    private(set) var errorMessage: String?

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

    func authenticateWithApple() {
        Current.appleAuthorizationService.requestAuthorization { result in
            switch result {
            case .success(let credential):
                Current.keychain.appleAuthorizationUserId = credential.userId
                isLoading = true
                Current.authenticationService.authenticateAppleAccount(with: credential) { result in
                    isLoading = false
                    switch result {
                    case .success:
                        // Firebase's Auth singleton makes this line redundant since it notifies listeners
                        // about user changes upon sign in. However if services are changed there's
                        // a chance this line might be needed.
                        // authenticationStatusObserver.statusDidChangeHandler(userCredential)
                        break
                    case .failure(let error):
                        handleAuthenticationError(error)
                    }
                }
            case .failure(let error):
                handleAuthorizationError(error)
            }
        }
    }

    private func handleAuthorizationError(_ error: AppleAuthorizationService.Error) {
        switch error.code {
        case .notHandled:
            preconditionFailure(error.localizedDescription)
        case .failed, .invalidResponse, .unknown:
            errorMessage = error.localizedDescription
        case .canceled:
            break
        @unknown default:
            break
        }
    }

    private func handleAuthenticationError(_ error: AuthenticationSignInError) {
        switch error.reasonCode {
        case .invalidAPIKey,
             .appNotAuthorized,
             .internalError,
             .operationNotAllowed:
            preconditionFailure("\(error.localizedDescription) (\(error.reasonCode.rawValue))")
        case .unknown,
             .networkError,
             .tooManyRequests,
             .invalidCredential,
             .userDisabled,
             .invalidEmail,
             .missingOrInvalidNonce:
            errorMessage = "\(error.localizedDescription) (\(error.reasonCode.rawValue))"
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
