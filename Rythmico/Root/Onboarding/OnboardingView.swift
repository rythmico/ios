import SwiftUI
import Sugar

struct OnboardingView: View, TestableView {
    @State
    var isLoading: Bool = false
    var isAppleAuthorizationButtonEnabled: Bool { !isLoading }

    @State
    var errorMessage: String?

    var onAppear: Handler<Self>?
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            VStack(spacing: .spacingSmall) {
                Spacer()
                VStack(spacing: .spacingSmall) {
                    Text("Rythmico")
                        .rythmicoFont(.largeTitle)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.rythmicoForeground)
                }
                .accessibilityElement(children: .combine)
                Spacer()
                if isLoading {
                    ActivityIndicator(style: .medium, color: .rythmicoGray90)
                        .frame(width: 44, height: 44)
                } else {
                    AuthorizationAppleIDButton()
                        .accessibility(hint: Text("Double tap to sign in with your Apple ID"))
                        .onTapGesture(perform: authenticateWithApple)
                        .disabled(!isAppleAuthorizationButtonEnabled)
                }
            }
            .padding(.spacingLarge)
            .animation(.rythmicoSpring(duration: .durationMedium), value: isLoading)
        }
        .alert(item: $errorMessage) {
            Alert(title: Text("An error ocurred"), message: Text($0))
        }
        .onDisappear {
            Current.uiAccessibility.postAnnouncement("Welcome")
        }
        .onAppear { self.onAppear?(self) }
        .onAppear(perform: Current.deviceUnregisterCoordinator().unregisterDevice)
    }

    func authenticateWithApple() {
        Current.appleAuthorizationService.requestAuthorization { result in
            switch result {
            case .success(let credential):
                Current.keychain.appleAuthorizationUserId = credential.userId
                self.isLoading = true
                Current.authenticationService.authenticateAppleAccount(with: credential) { result in
                    self.isLoading = false
                    switch result {
                    case .success:
                        // Firebase's Auth singleton makes this line redundant since it notifies listeners
                        // about user changes upon sign in. However if services are changed there's
                        // a chance this line might be needed.
                        // self.authenticationStatusObserver.statusDidChangeHandler(accessTokenProvider)
                        break
                    case .failure(let error):
                        self.handleAuthenticationError(error)
                    }
                }
            case .failure(let error):
                self.handleAuthorizationError(error)
            }
        }
    }

    private func handleAuthorizationError(_ error: AppleAuthorizationService.Error) {
        switch error.code {
        case .notHandled:
            preconditionFailure(error.localizedDescription)
        case .canceled, .failed, .invalidResponse, .unknown:
            break
        @unknown default:
            break
        }
    }

    private func handleAuthenticationError(_ error: AuthenticationAPIError) {
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
        Current.appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
        Current.authenticationService = AuthenticationServiceStub(
            result: .success(AuthenticationAccessTokenProviderStub(result: .success(""))),
            delay: 2,
            accessTokenProviderObserver: Current.accessTokenProviderObserver
        )

        return Group {
            OnboardingView()
                .environment(\.colorScheme, .light)
            OnboardingView()
                .environment(\.colorScheme, .dark)
                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        }
    }
}
#endif
