import XCTest
@testable import Rythmico
import class AuthenticationServices.ASAuthorizationAppleIDRequest
import struct CryptoKit.SHA256

final class AppleAuthorizationServiceTests: XCTestCase {
    func testRequestAuthorization_createsControllerAndRequestWithCorrectScopesAndHashedNonce() throws {
        let expectationA = self.expectation(description: "AppleAuthorizationController is initialized")

        let nonce = "NONCE123"
        let hashedNonce = SHA256.hashString(utf8String: nonce)

        AppleAuthorizationControllerSpy.didInit = { controller in
            expectationA.fulfill()

            XCTAssertEqual(controller.authorizationRequests.count, 1)

            guard let request = controller.authorizationRequests.first as? ASAuthorizationAppleIDRequest else {
                XCTFail("Expected ASAuthorizationAppleIDRequest type")
                return
            }

            XCTAssertEqual(request.requestedScopes, [.fullName, .email])
            XCTAssertEqual(request.nonce, hashedNonce)
        }

        let service = AppleAuthorizationService(controllerType: AppleAuthorizationControllerSpy.self)
        service.requestAuthorization(nonce: nonce) { _ in }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRequestAuthorization_setsControllerDelegateAndPerformsRequestAfterwards() throws {
        let expectationA = self.expectation(description: "Delegate is set")
        let expectationB = self.expectation(description: "Request is performed")

        AppleAuthorizationControllerSpy.didInit = { controller in
            controller.didSetDelegate = { delegate in
                expectationA.fulfill()
            }

            controller.didPerformRequests = {
                expectationB.fulfill()
            }
        }

        let service = AppleAuthorizationService(controllerType: AppleAuthorizationControllerSpy.self)
        service.requestAuthorization { _ in }

        wait(for: [expectationA, expectationB], timeout: 1, enforceOrder: true)
    }

    func testRequestAuthorization_completionHandlerIsSuccess_forControllerDelegateSuccessCallback() throws {
        let expectation = self.expectation(description: "Request completes successfully")

        let userId = "USER_ID"
        var fullName = PersonNameComponents()
        fullName.givenName = "David"
        fullName.familyName = "Roman Aguirre"
        let email = "d@vidroman.dev"
        let identityToken = "IDTOKEN123"
        let nonce = "NONCE123"

        AppleAuthorizationControllerSpy.didInit = { controller in
            controller.didSetDelegate = { delegate in
                guard let delegate = delegate as? AppleAuthorizationCompletionDelegate else {
                    XCTFail("Delegate is not of expected type AppleAuthorizationCompletionDelegate")
                    return
                }
                let credential = AppleAuthorizationResponseStub(userId: userId, fullName: fullName, email: email, identityToken: identityToken)
                delegate.authorizationCompletionHandler(.success(credential))
            }
        }

        let service = AppleAuthorizationService(controllerType: AppleAuthorizationControllerSpy.self)
        service.requestAuthorization(nonce: nonce) { result in
            switch result {
            case .success(let credential):
                expectation.fulfill()
                let expectedCredential = AppleAuthorizationService.Credential(
                    userId: userId,
                    fullName: "David Roman Aguirre",
                    email: "d@vidroman.dev",
                    identityToken: identityToken,
                    nonce: nonce
                )
                XCTAssertEqual(expectedCredential, credential)
            case .failure(let error):
                XCTFail("Should not fail with error \(error)")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRequestAuthorization_completionHandlerIsFailure_forControllerDelegateFailureCallback() throws {
        let expectation = self.expectation(description: "Request completes unsuccessfully")

        AppleAuthorizationControllerSpy.didInit = { controller in
            controller.didSetDelegate = { delegate in
                guard let delegate = delegate as? AppleAuthorizationCompletionDelegate else {
                    XCTFail("Delegate is not of expected type AppleAuthorizationCompletionDelegate")
                    return
                }
                delegate.authorizationCompletionHandler(.failure(.init(.unknown)))
            }
        }

        let service = AppleAuthorizationService(controllerType: AppleAuthorizationControllerSpy.self)
        service.requestAuthorization { result in
            switch result {
            case .success(let response):
                XCTFail("Should not succeed with response \(response)")
            case .failure(let error):
                expectation.fulfill()
                XCTAssertEqual(error.code, .unknown)
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRequestAuthorization_completionHandlerIsFailure_forControllerDelegateSuccessCallback_withNilIdentityTokenCredential() throws {
        let expectation = self.expectation(description: "Request completes unsuccessfully")

        AppleAuthorizationControllerSpy.didInit = { controller in
            controller.didSetDelegate = { delegate in
                guard let delegate = delegate as? AppleAuthorizationCompletionDelegate else {
                    XCTFail("Delegate is not of expected type AppleAuthorizationCompletionDelegate")
                    return
                }
                delegate.authorizationCompletionHandler(.success(AppleAuthorizationResponseDummy()))
            }
        }

        let service = AppleAuthorizationService(controllerType: AppleAuthorizationControllerSpy.self)
        service.requestAuthorization { result in
            switch result {
            case .success(let response):
                XCTFail("Should not succeed with response \(response)")
            case .failure(let error):
                expectation.fulfill()
                XCTAssertEqual(error.code, .invalidResponse)
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
