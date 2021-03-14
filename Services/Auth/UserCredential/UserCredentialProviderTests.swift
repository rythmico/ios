import XCTest
@testable import Rythmico

final class UserCredentialProviderTests: XCTestCase {
    func testInit() {
        let expectation = self.expectation(description: "Listener is added to emitter")

        let emitterSpy = UserCredentialEmitterSpy(userCredential: nil, returnedToken: 0)
        emitterSpy.didAddStateDidChangeListener = { listener in
            expectation.fulfill()
            listener(UserCredentialDummy())
        }

        _ = UserCredentialProvider(emitter: emitterSpy)

        wait(for: [expectation], timeout: 1)
    }

    func testDeinit() {
        // Using waiter because it tracks deinitialized objects, unlike `self.wait`
        let waiter = XCTWaiter()
        let expectation = self.expectation(description: "Listener is removed from emitter upon deinit")

        let emitterSpy = UserCredentialEmitterSpy(userCredential: nil, returnedToken: 1)
        emitterSpy.didRemoveStateDidChangeListener = { token in
            XCTAssertEqual(token as? Int, 1)
            expectation.fulfill()
        }

        _ = UserCredentialProvider(emitter: emitterSpy)

        waiter.wait(for: [expectation], timeout: 1)
    }
}
