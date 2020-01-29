import XCTest
@testable import Rythmico
import Auth
import AuthenticationServices

final class OnboardingViewModelTests: XCTestCase {
    func authorizationService(withErrorCode code: ASAuthorizationError.Code) -> AppleAuthorizationServiceStub {
        AppleAuthorizationServiceStub(expectedResult: .failure(ASAuthorizationError(code)))
    }

    func authenticationService(withErrorCode code: AuthenticationAPIError.ReasonCode) -> AuthenticationServiceStub {
        AuthenticationServiceStub(expectedResult: .failure(AuthenticationAPIError(reasonCode: code, localizedDescription: "Whooopsie")))
    }

    var credential: AppleAuthorizationCredential {
        AppleAuthorizationCredential(
            userId: "USER_ID",
            fullName: "First Second",
            email: "a@b.c",
            identityToken: "IDENTITY_TOKEN",
            nonce: "NONCE"
        )
    }

    func testFailedAuthorization() {
        let keychain = KeychainFake()

        let viewModel = OnboardingViewModel(
            appleAuthorizationService: authorizationService(withErrorCode: .failed),
            authenticationService: AuthenticationServiceDummy(),
            keychain: keychain,
            dispatchQueue: nil
        )

        viewModel.showAppleAuthenticationSheet()

        XCTAssertFalse(viewModel.viewData.isLoading)
        XCTAssertNil(viewModel.viewData.errorMessage)
        XCTAssert(keychain.inMemoryStorage.isEmpty)
    }

    func testFailedAuthentication() {
        let keychain = KeychainFake()

        let viewModel = OnboardingViewModel(
            appleAuthorizationService: AppleAuthorizationServiceStub(expectedResult: .success(credential)),
            authenticationService: authenticationService(withErrorCode: .invalidCredential),
            keychain: keychain,
            dispatchQueue: nil
        )

        viewModel.showAppleAuthenticationSheet()

        XCTAssertFalse(viewModel.viewData.isLoading)
        XCTAssertEqual(viewModel.viewData.errorMessage, "Whooopsie (17004)")
        XCTAssertEqual(keychain.inMemoryStorage.values.count, 1)
        XCTAssertEqual(keychain.inMemoryStorage.values.first, "USER_ID")
    }

    func testSuccessfulAuthentication() {
        let keychain = KeychainFake()

        let viewModel = OnboardingViewModel(
            appleAuthorizationService: AppleAuthorizationServiceStub(expectedResult: .success(credential)),
            authenticationService: AuthenticationServiceStub(expectedResult: .success(AuthenticationAccessTokenProviderDummy())),
            keychain: keychain,
            dispatchQueue: nil
        )

        viewModel.showAppleAuthenticationSheet()

        XCTAssertFalse(viewModel.viewData.isLoading)
        XCTAssertNil(viewModel.viewData.errorMessage)
        XCTAssertEqual(keychain.inMemoryStorage.values.count, 1)
        XCTAssertEqual(keychain.inMemoryStorage.values.first, "USER_ID")
    }
}
