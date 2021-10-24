import XCTest
@testable import Rythmico
import class AuthenticationServices.ASAuthorizationAppleIDRequest
import struct CryptoKit.SHA256

final class SIWAAuthorizationServiceTests: XCTestCase {
    func testRequestAuthorization_createsControllerAndRequestWithCorrectScopesAndHashedNonce() throws {
        let expectationA = self.expectation(description: "SIWAController is initialized")

        let nonce = "NONCE123"
        let hashedNonce = SHA256.hashString(utf8String: nonce)

        SIWAAuthorizationControllerSpy.didInit = { controller in
            expectationA.fulfill()

            XCTAssertEqual(controller.authorizationRequests.count, 1)

            guard let request = controller.authorizationRequests.first as? ASAuthorizationAppleIDRequest else {
                XCTFail("Expected ASAuthorizationAppleIDRequest type")
                return
            }

            XCTAssertEqual(request.requestedScopes, [.fullName, .email])
            XCTAssertEqual(request.nonce, hashedNonce)
        }

        let service = SIWAAuthorizationService(controllerType: SIWAAuthorizationControllerSpy.self)
        service.requestAuthorization(nonce: nonce) { _ in }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRequestAuthorization_setsControllerDelegateAndPerformsRequestAfterwards() throws {
        let expectationA = self.expectation(description: "Delegate is set")
        let expectationB = self.expectation(description: "Request is performed")

        SIWAAuthorizationControllerSpy.didInit = { controller in
            controller.didSetDelegate = { delegate in
                expectationA.fulfill()
            }

            controller.didPerformRequests = {
                expectationB.fulfill()
            }
        }

        let service = SIWAAuthorizationService(controllerType: SIWAAuthorizationControllerSpy.self)
        service.requestAuthorization { _ in }

        wait(for: [expectationA, expectationB], timeout: 1, enforceOrder: true)
    }

    func testRequestAuthorization_completionHandlerIsSuccess_forControllerDelegateSuccessCallback() throws {
        let expectation = self.expectation(description: "Request completes successfully")

        let userID = "USER_ID"
        var fullName = PersonNameComponents()
        fullName.givenName = "David"
        fullName.familyName = "Roman"
        let email = "d@vidroman.dev"
        let identityToken = "IDTOKEN123"
        let nonce = "NONCE123"

        SIWAAuthorizationControllerSpy.didInit = { controller in
            controller.didSetDelegate = { delegate in
                guard let delegate = delegate as? SIWAAuthorizationCompletionDelegate else {
                    XCTFail("Delegate is not of expected type SIWACompletionDelegate")
                    return
                }
                let credential = SIWAAuthorizationResponseStub(userID: userID, fullName: fullName, email: email, identityToken: identityToken)
                delegate.handler(.success(credential))
            }
        }

        let service = SIWAAuthorizationService(controllerType: SIWAAuthorizationControllerSpy.self)
        service.requestAuthorization(nonce: nonce) { result in
            switch result {
            case .success(let credential):
                expectation.fulfill()
                let expectedCredential = SIWAAuthorizationService.Credential(
                    userInfo: .init(
                        userID: userID,
                        name: "David Roman",
                        email: "d@vidroman.dev"
                    ),
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

        SIWAAuthorizationControllerSpy.didInit = { controller in
            controller.didSetDelegate = { delegate in
                guard let delegate = delegate as? SIWAAuthorizationCompletionDelegate else {
                    XCTFail("Delegate is not of expected type SIWACompletionDelegate")
                    return
                }
                delegate.handler(.failure(.init(.unknown)))
            }
        }

        let service = SIWAAuthorizationService(controllerType: SIWAAuthorizationControllerSpy.self)
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

        SIWAAuthorizationControllerSpy.didInit = { controller in
            controller.didSetDelegate = { delegate in
                guard let delegate = delegate as? SIWAAuthorizationCompletionDelegate else {
                    XCTFail("Delegate is not of expected type SIWACompletionDelegate")
                    return
                }
                delegate.handler(.success(SIWAAuthorizationResponseDummy()))
            }
        }

        let service = SIWAAuthorizationService(controllerType: SIWAAuthorizationControllerSpy.self)
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
