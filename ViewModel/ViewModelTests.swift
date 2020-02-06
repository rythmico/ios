import XCTest
@testable import ViewModel

final class ViewModelObjectTests: XCTestCase {
    func testObjectWillChange_deliversChangesOnMainThreadAlways() {
        struct ViewDataMock { var a: Int }

        let expectation = self.expectation(description: "a is set")
        expectation.expectedFulfillmentCount = 3

        let viewModel = ViewModelObject<ViewDataMock>(viewData: ViewDataMock(a: 0))
        let cancellable = viewModel.objectWillChange.eraseToAnyPublisher().sink { _ in
            XCTAssert(Thread.isMainThread)
            expectation.fulfill()
        }

        viewModel.viewData.a = 1

        viewModel.viewData.a = 2

        DispatchQueue(label: "background", qos: .background).async {
            viewModel.viewData.a = 3
        }

        wait(for: [expectation], timeout: 2)

        XCTAssertNotNil(cancellable)
    }
}
