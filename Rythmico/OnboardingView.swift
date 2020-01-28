import SwiftUI

struct OnboardingViewData {
    var isLoading: Bool = false
    var isAppleAuthorizationButtonEnabled: Bool { !isLoading }
    var errorMessage: String? = nil
}

struct OnboardingView: View, ViewModelable {
    @ObservedObject var viewModel: OnboardingViewModel

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
            VStack(spacing: 16) {
                Spacer()
                Text("Rythmico").rythmicoFont(.largeTitle)
                Text("Turning kids into the festival headliners of tomorrow")
                    .rythmicoFont(.headline)
                    .multilineTextAlignment(.center)
                if viewData.isLoading {
                    Text("Loading...")
                }
                Spacer()
                AuthorizationAppleIDButton()
                    .onTapGesture(perform: viewModel.showAppleAuthenticationSheet)
                    .opacity(viewData.isAppleAuthorizationButtonEnabled ? 1 : 0.3)
                    .disabled(!viewData.isAppleAuthorizationButtonEnabled)
            }
            .padding()
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
            OnboardingView(viewModel: onboardingViewModel).environment(\.sizeCategory, $0)
        }
    }

    private static var onboardingViewModel: OnboardingViewModel {
        OnboardingViewModel(
            appleAuthorizationService: authorizationService,
            authenticationService: authenticationService,
            keychain: keychain,
            dispatchQueue: nil
        )
    }

    private static var authorizationService: AppleAuthorizationServiceProtocol {
        let credentials = AppleAuthorizationServiceStub.Credential(
            userId: "USER_ID",
            identityToken: "IDENTITY_TOKEN",
            nonce: "NONCE"
        )
        return AppleAuthorizationServiceStub(expectedResult: .success(credentials))
    }

    private static var authenticationService: AuthenticationServiceProtocol {
        AuthenticationServiceStub(expectedResult: .success(authenticationAccessTokenProvider))
    }

    private static var keychain: KeychainProtocol {
        KeychainFake()
    }

    private static var authenticationAccessTokenProvider: AuthenticationAccessTokenProvider {
        AuthenticationAccessTokenProviderStub(expectedResult: .success("ACCESS_TOKEN"))
    }
}
