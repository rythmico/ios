import XCTest
@testable import Auth

final class AuthenticationAccessTokenProviderObserverTests: XCTestCase {
    func testInit() {
        let expectationA = self.expectation(description: "Current provider is called back")
        let expectationB = self.expectation(description: "Listener is added to broadcast")
        let expectationC = self.expectation(description: "Listener closure is as provided")

        let broadcastSpy = AuthenticationAccessTokenProviderBroadcastSpy(currentProvider: nil, returnedToken: 0)
        broadcastSpy.didAddStateDidChangeListener = { listener in
            expectationB.fulfill()
            listener(AuthenticationAccessTokenProviderDummy())
        }

        let observer = AuthenticationAccessTokenProviderObserver(broadcast: broadcastSpy)
        observer.statusDidChangeHandler = { provider in
            if provider == nil {
                expectationA.fulfill()
            } else {
                expectationC.fulfill()
            }
        }

        wait(for: [expectationA, expectationB, expectationC], timeout: 1, enforceOrder: true)
    }

    func testSetStatusDidChangeHandler() {
        let expectationA = self.expectation(description: "Listener closure 1 is as provided")
            expectationA.expectedFulfillmentCount = 2
        let expectationB = self.expectation(description: "Listener 1 is removed from broadcast")
        let expectationC = self.expectation(description: "Listener closure 2 is as provided")
            expectationC.expectedFulfillmentCount = 2

        let broadcastSpy = AuthenticationAccessTokenProviderBroadcastSpy(currentProvider: nil, returnedToken: 1)
        broadcastSpy.didAddStateDidChangeListener = { listener in
            listener(AuthenticationAccessTokenProviderDummy())
        }
        broadcastSpy.didRemoveStateDidChangeListener = { token in
            if token as? Int == 1 {
                expectationB.fulfill()
            }
        }

        let observer = AuthenticationAccessTokenProviderObserver(broadcast: broadcastSpy)
        observer.statusDidChangeHandler = { provider in
            expectationA.fulfill()
        }

        broadcastSpy.returnedToken = 2

        observer.statusDidChangeHandler = { _ in
            expectationC.fulfill()
        }

        wait(
            for: [
                expectationA,
                expectationB,
                expectationC
            ],
            timeout: 1,
            enforceOrder: true
        )
    }

    func testDeinit() {
        // Using waiter because it tracks deinitialized objects as opposed to just calling `self.wait`
        let waiter = XCTWaiter()
        let expectation = self.expectation(description: "Listener is removed from broadcast upon deinit")

        let broadcastSpy = AuthenticationAccessTokenProviderBroadcastSpy(currentProvider: nil, returnedToken: 1)
        broadcastSpy.didRemoveStateDidChangeListener = { token in
            XCTAssertEqual(token as? Int, 1)
            expectation.fulfill()
        }

        let observer = AuthenticationAccessTokenProviderObserver(broadcast: broadcastSpy)
        observer.statusDidChangeHandler = { _ in }

        waiter.wait(for: [expectation], timeout: 1, enforceOrder: true)
    }
}
