import XCTest
@testable import Tutor
import AuthenticationServices

final class OnboardingViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
    }

    func testDeviceUnregistrationOnAppear() {
        let spy = DeviceTokenDeleterSpy()
        Current.deviceTokenDeleter = spy

        let view = OnboardingView()

        XCTAssertView(view) { view in
            XCTAssertEqual(spy.unregisterCount, 1)
        }
    }

    func testFailedAuthorization() {
        Current.appleAuthorizationService = AppleAuthorizationServiceStub(result: .failure(.init(.failed)))

        let keychain = KeychainFake()
        Current.keychain = keychain

        let view = OnboardingView()

        XCTAssertView(view) { view in
            view.authenticateWithApple()
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.errorMessage)
            XCTAssert(keychain.inMemoryStorage.isEmpty)
        }
    }

    func testFailedAuthentication() {
        Current.appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
        Current.authenticationService = AuthenticationServiceStub(
            result: .failure(.init(reasonCode: .invalidCredential, localizedDescription: "Whooopsie"))
        )

        let keychain = KeychainFake()
        Current.keychain = keychain

        let view = OnboardingView()

        XCTAssertView(view) { view in
            view.authenticateWithApple()

            XCTAssertFalse(view.isLoading)
            XCTAssertEqual(view.errorMessage, "Whooopsie (17004)")
            XCTAssertEqual(keychain.inMemoryStorage.values.count, 1)
            XCTAssertEqual(keychain.inMemoryStorage.values.first, "USER_ID")

            view.dismissError()
            XCTAssertNil(view.errorMessage)
        }
    }

    func testSuccessfulAuthentication() {
        Current.appleAuthorizationService = AppleAuthorizationServiceStub(result: .success(.stub))
        Current.authenticationService = AuthenticationServiceStub(
            result: .success(AuthenticationAccessTokenProviderStub(result: .success("ACCESS_TOKEN")))
        )

        let keychain = KeychainFake()
        Current.keychain = keychain

        let view = OnboardingView()

        XCTAssertView(view) { view in
            view.authenticateWithApple()
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.errorMessage)
            XCTAssertEqual(keychain.inMemoryStorage.values.count, 1)
            XCTAssertEqual(keychain.inMemoryStorage.values.first, "USER_ID")
        }
    }
}
