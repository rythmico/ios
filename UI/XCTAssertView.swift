import SwiftUI
@testable import Rythmico
import XCTest
import ViewInspector

public func XCTAssertView<TV: TestableView>(
    _ view: TV,
    message: String = "",
    assertion: @escaping (TV) -> Void
) {
    let expectation = XCTestExpectation(description: message)
    var view = view

    view.didAppear = { view in
        assertion(view)
        expectation.fulfill()
    }

    ViewHosting.host(view: view)
    XCTWaiter().wait(for: [expectation], timeout: 1)
}
