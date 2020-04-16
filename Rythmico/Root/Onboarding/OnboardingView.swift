import SwiftUI
import Sugar

struct OnboardingView: View, TestableView {
    private let appleAuthorizationService: AppleAuthorizationServiceProtocol
    private let authenticationService: AuthenticationServiceProtocol
    private let keychain: KeychainProtocol

    @State
    var isLoading: Bool = false
    var isAppleAuthorizationButtonEnabled: Bool { !isLoading }

    @State
    var errorMessage: String?

    init(
        appleAuthorizationService: AppleAuthorizationServiceProtocol,
        authenticationService: AuthenticationServiceProtocol,
        keychain: KeychainProtocol
    ) {
        self.appleAuthorizationService = appleAuthorizationService
        self.authenticationService = authenticationService
        self.keychain = keychain
    }

    var didAppear: Handler<Self>?
    var body: some View {
        ZStack {
            Color.rythmicoPurple.edgesIgnoringSafeArea(.all)
            VStack(spacing: .spacingSmall) {
                Spacer()
                VStack(spacing: .spacingSmall) {
                    Text("Rythmico")
                        .rythmicoFont(.largeTitle)
                        .foregroundColor(.white)
                    Text("Turning kids into the festival headliners of tomorrow")
                        .rythmicoFont(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .accessibilityElement(children: .combine)
                Spacer()
                if isLoading {
                    ActivityIndicator(style: .medium, color: .lightGray)
                        .frame(width: 44, height: 44)
                } else {
                    AuthorizationAppleIDButton()
                        .environment(\.colorScheme, .dark)
                        .accessibility(hint: Text("Double tap to sign in with your Apple ID"))
                        .onTapGesture(perform: authenticateWithApple)
                        .disabled(!isAppleAuthorizationButtonEnabled)
                }
            }
            .padding()
            .animation(.rythmicoSpring(duration: .durationMedium), value: isLoading)
        }
        .alert(item: $errorMessage) {
            Alert(title: Text("An error ocurred"), message: Text($0))
        }
        .onDisappear {
            UIAccessibility.post(notification: .announcement, argument: "Welcome")
        }
        .onAppear { self.didAppear?(self) }
    }

    func authenticateWithApple() {
        appleAuthorizationService.requestAuthorization { result in
            switch result {
            case .success(let credential):
                self.keychain.appleAuthorizationUserId = credential.userId
                self.isLoading = true
                self.authenticationService.authenticateAppleAccount(with: credential) { result in
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

    private func handleAuthenticationError(_ error: AuthenticationServiceProtocol.Error) {
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

struct OnboardingView_Preview: PreviewProvider {
    static var previewCategorySizes: [ContentSizeCategory] {
        [
            ContentSizeCategory.allCases.dropFirst(2).first,
            ContentSizeCategory.allCases.last
        ].compactMap { $0 }
    }

    static var previews: some View {
        ForEach(previewCategorySizes, id: \.self) {
            OnboardingView(
                appleAuthorizationService: authorizationService,
                authenticationService: authenticationService,
                keychain: keychain
            ).environment(\.sizeCategory, $0)
        }
    }

    private static var authorizationService: AppleAuthorizationServiceProtocol {
        AppleAuthorizationServiceStub(expectedResult: .success(
            AppleAuthorizationServiceStub.Credential(
                userId: "USER_ID",
                fullName: nil,
                email: nil,
                identityToken: "IDENTITY_TOKEN",
                nonce: "NONCE"
            )
        ))
    }

    private static var authenticationService: AuthenticationServiceProtocol {
        AuthenticationServiceStub(expectedResult: .failure(.init(reasonCode: .invalidEmail, localizedDescription: "Something went ooopsie!")))
    }

    private static var keychain: KeychainProtocol {
        KeychainFake()
    }

    private static var authenticationAccessTokenProvider: AuthenticationAccessTokenProvider {
        AuthenticationAccessTokenProviderStub(expectedResult: .success("ACCESS_TOKEN"))
    }
}
