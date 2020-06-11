import XCTest
@testable import Rythmico
import AuthenticationServices

final class OnboardingViewTests: XCTestCase {
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

    func testPushNotificationsUnregistrationOnAppear() {
        let spy = DeviceUnregisterServiceSpy()

        let view = OnboardingView(
            appleAuthorizationService: authorizationService(withErrorCode: .failed),
            authenticationService: AuthenticationServiceDummy(),
            keychain: KeychainFake(),
            pushNotificationUnregistrationService: spy
        )

        XCTAssertView(view) { view in
            XCTAssertEqual(spy.unregisterCount, 1)
        }
    }

    func testFailedAuthorization() {
        let keychain = KeychainFake()

        let view = OnboardingView(
            appleAuthorizationService: authorizationService(withErrorCode: .failed),
            authenticationService: AuthenticationServiceDummy(),
            keychain: keychain,
            pushNotificationUnregistrationService: DeviceUnregisterServiceDummy()
        )

        XCTAssertView(view) { view in
            view.authenticateWithApple()
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.errorMessage)
            XCTAssert(keychain.inMemoryStorage.isEmpty)
        }
    }

    func testFailedAuthentication() {
        let keychain = KeychainFake()

        let view = OnboardingView(
            appleAuthorizationService: AppleAuthorizationServiceStub(expectedResult: .success(credential)),
            authenticationService: authenticationService(withErrorCode: .invalidCredential),
            keychain: keychain,
            pushNotificationUnregistrationService: DeviceUnregisterServiceDummy()
        )

        XCTAssertView(view) { view in
            view.authenticateWithApple()

            XCTAssertFalse(view.isLoading)
            XCTAssertEqual(view.errorMessage, "Whooopsie (17004)")
            XCTAssertEqual(keychain.inMemoryStorage.values.count, 1)
            XCTAssertEqual(keychain.inMemoryStorage.values.first, "USER_ID")
        }
    }

    func testSuccessfulAuthentication() {
        let keychain = KeychainFake()

        let view = OnboardingView(
            appleAuthorizationService: AppleAuthorizationServiceStub(expectedResult: .success(credential)),
            authenticationService: AuthenticationServiceStub(expectedResult: .success(AuthenticationAccessTokenProviderDummy())),
            keychain: keychain,
            pushNotificationUnregistrationService: DeviceUnregisterServiceDummy()
        )

        XCTAssertView(view) { view in
            view.authenticateWithApple()
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.errorMessage)
            XCTAssertEqual(keychain.inMemoryStorage.values.count, 1)
            XCTAssertEqual(keychain.inMemoryStorage.values.first, "USER_ID")
        }
    }
}
