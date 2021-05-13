import SwiftUI
#if RYTHMICO_TESTS
@testable import Rythmico
#elseif TUTOR_TESTS
@testable import Tutor
#endif
import XCTest
import ViewInspector
import Combine

extension Inspection: InspectionEmissary where V: Inspectable { }

func XCTAssertView<TV: TestableView & Inspectable>(
    _ view: TV,
    after interval: TimeInterval? = nil,
    message: String = "",
    assertion: @escaping (TV) throws -> Void
) rethrows {
    let expectation = XCTestExpectation(description: message)
    let timeout: TimeInterval

    if let interval = interval {
        timeout = interval * 2
        view.inspection.inspect(after: interval) { view in
            try assertion(view.actualView())
            expectation.fulfill()
        }
    } else {
        timeout = 0
        view.inspection.inspect { view in
            try assertion(view.actualView())
            expectation.fulfill()
        }
    }

    ViewHosting.host(view: view)
    XCTWaiter().wait(for: [expectation], timeout: max(timeout, XCTAssertViewTimeoutDefault))
}

private let XCTAssertViewTimeoutDefault: TimeInterval = 0.25
