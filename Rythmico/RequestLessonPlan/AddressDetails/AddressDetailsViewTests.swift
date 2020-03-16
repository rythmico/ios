import XCTest
import SwiftUI
import Sugar
@testable import Rythmico

final class AddressDetailsViewTests: XCTestCase {
    private enum ErrorStub: Swift.Error {
        case stub
    }

    func addressDetailsView(
        result: SimpleResult<[Address]>
    ) -> (
        RequestLessonPlanContext,
        AddressProviderSpy,
        AddressDetailsView
    ) {
        let addressProvider = AddressProviderSpy(result: result)
        let context = RequestLessonPlanContext()
        return (
            context,
            addressProvider,
            AddressDetailsView(
                student: .davidStub,
                instrument: .guitarStub,
                state: .init(),
                context: context,
                addressProvider: addressProvider,
                editingCoordinator: EditingCoordinatorSpy()
            )
        )
    }

    func testInitialValues() {
        let (context, _, view) = addressDetailsView(result: .success([.stub]))

        XCTAssertView(view) { view in
            XCTAssertNil(context.address)

            XCTAssertEqual(view.subtitle.string, "Enter the address where David will have the Guitar lessons")
            XCTAssertTrue(view.state.postcode.isEmpty)
            XCTAssertNil(view.state.addresses)
            XCTAssertNil(view.state.selectedAddress)

            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.errorMessage)
            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testSearchAddresses_failure() {
        let (_, provider, view) = addressDetailsView(result: .failure(ErrorStub.stub))

        XCTAssertView(view) { view in
            view.state.postcode = "N7"
            view.state.postcode = ""
            view.searchAddresses()

            XCTAssertEqual(provider.searchCount, 1)
            XCTAssertEqual(provider.latestPostcode, "")

            XCTAssertNotNil(view.errorMessage)
            XCTAssertNil(view.state.addresses)
            XCTAssertNil(view.state.selectedAddress)
        }
    }

    func testSearchAddresses_success() {
        let (_, provider, view) = addressDetailsView(result: .success([.stub]))

        XCTAssertView(view) { view in
            view.state.postcode = "N7"
            view.state.postcode = "N7 9FU"
            view.searchAddresses()

            XCTAssertEqual(provider.searchCount, 1)
            XCTAssertEqual(provider.latestPostcode, "N7 9FU")

            XCTAssertNil(view.errorMessage)
            XCTAssert(view.state.addresses?.isEmpty == false)
            XCTAssertNil(view.state.selectedAddress)
        }
    }

    func testAddressSelectionEnablesNextButton() {
        let (_, _, view) = addressDetailsView(result: .success([.stub]))

        XCTAssertView(view) { view in
            view.searchAddresses()
            view.state.selectedAddress = .stub
            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsAddressDetailsInContext() {
        let (context, _, view) = addressDetailsView(result: .success([.stub]))

        XCTAssertView(view) { view in
            view.searchAddresses()
            view.state.selectedAddress = .stub
            view.nextButtonAction?()
            XCTAssertEqual(context.address, .stub)
        }
    }
}
