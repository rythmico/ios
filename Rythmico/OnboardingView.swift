import SwiftUI
import Auth
import Sugar

struct OnboardingViewData {
    struct ErrorAlertViewData: Identifiable {
        var id = UUID()
        var message: String
    }

    var isLoading: Bool = false
    var isAppleAuthorizationButtonEnabled: Bool { !isLoading }
    var errorAlertViewData: ErrorAlertViewData? = nil
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
                    .onTapGesture(perform: viewModel.authenticateWithApple)
                    .opacity(viewData.isAppleAuthorizationButtonEnabled ? 1 : 0.3)
                    .disabled(!viewData.isAppleAuthorizationButtonEnabled)
            }
            .padding()
        }
        .alert(item: Binding(get: { self.viewData.errorAlertViewData }, set: { _ in self.viewModel.dismissErrorAlert() })) { viewData in
            Alert(title: Text("An error ocurred"), message: Text(viewData.message))
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
            fullName: nil,
            email: nil,
            identityToken: "IDENTITY_TOKEN",
            nonce: "NONCE"
        )
        return AppleAuthorizationServiceStub(expectedResult: .success(credentials))
    }

    private static var authenticationService: AuthenticationServiceProtocol {
//        AuthenticationServiceStub(expectedResult: .success(authenticationAccessTokenProvider))
        AuthenticationServiceStub(expectedResult: .failure(.init(reasonCode: .invalidEmail, localizedDescription: "Something went ooopsie!")))
    }

    private static var keychain: KeychainProtocol {
        KeychainFake()
    }

    private static var authenticationAccessTokenProvider: AuthenticationAccessTokenProvider {
        AuthenticationAccessTokenProviderStub(expectedResult: .success("ACCESS_TOKEN"))
    }
}
