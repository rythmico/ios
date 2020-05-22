import XCTest
@testable import Rythmico

final class AuthenticationAccessTokenProviderObserverTests: XCTestCase {
    func testInit() {
        let expectation = self.expectation(description: "Listener is added to broadcast")

        let broadcastSpy = AuthenticationAccessTokenProviderBroadcastSpy(currentProvider: nil, returnedToken: 0)
        broadcastSpy.didAddStateDidChangeListener = { listener in
            expectation.fulfill()
            listener(AuthenticationAccessTokenProviderDummy())
        }

        _ = AuthenticationAccessTokenProviderObserver(broadcast: broadcastSpy)

        wait(for: [expectation], timeout: 1)
    }

    func testDeinit() {
        // Using waiter because it tracks deinitialized objects, unlike `self.wait`
        let waiter = XCTWaiter()
        let expectation = self.expectation(description: "Listener is removed from broadcast upon deinit")

        let broadcastSpy = AuthenticationAccessTokenProviderBroadcastSpy(currentProvider: nil, returnedToken: 1)
        broadcastSpy.didRemoveStateDidChangeListener = { token in
            XCTAssertEqual(token as? Int, 1)
            expectation.fulfill()
        }

        _ = AuthenticationAccessTokenProviderObserver(broadcast: broadcastSpy)

        waiter.wait(for: [expectation], timeout: 1)
    }
}
