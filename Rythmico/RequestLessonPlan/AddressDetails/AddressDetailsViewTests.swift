import XCTest
import SwiftUI
import Sugar
@testable import Rythmico

final class AddressDetailsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func addressDetailsView(
        result: SimpleResult<[AddressDetails]>
    ) throws -> (
        RequestLessonPlanContext,
        AddressSearchServiceSpy,
        AddressDetailsView
    ) {
        let addressSearchService = AddressSearchServiceSpy(result: result)
        Current.addressSearchService = addressSearchService
        let context = RequestLessonPlanContext()
        return try (
            context,
            addressSearchService,
            AddressDetailsView(
                student: .davidStub,
                instrument: .guitar,
                state: .init(),
                searchCoordinator: XCTUnwrap(Current.addressSearchCoordinator()),
                context: context
            )
        )
    }

    func testInitialValues() throws {
        let (context, _, view) = try addressDetailsView(result: .success([.stub]))

        XCTAssertView(view) { view in
            XCTAssertNil(context.address)

            XCTAssertEqual(view.subtitle.string, "Enter the address where David will have the Guitar lessons")
            XCTAssertTrue(view.state.postcode.isEmpty)
            XCTAssertNil(view.state.selectedAddress)

            XCTAssertNil(view.addresses)
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.errorMessage)
            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testSearchAddresses_failure() throws {
        let (_, provider, view) = try addressDetailsView(result: .failure("Something"))

        XCTAssertView(view) { view in
            view.state.postcode = "N7"
            view.state.postcode = ""
            view.searchAddresses()

            XCTAssertEqual(provider.searchCount, 1)
            XCTAssertEqual(provider.latestPostcode, "")

            XCTAssertEqual(view.errorMessage, "Something")
            XCTAssertNil(view.addresses)
            XCTAssertNil(view.state.selectedAddress)

            view.dismissError()
            XCTAssertNil(view.errorMessage)
        }
    }

    func testSearchAddresses_success() throws {
        let (_, provider, view) = try addressDetailsView(result: .success([.stub]))

        XCTAssertView(view) { view in
            view.state.postcode = "N7"
            view.state.postcode = "N7 9FU"
            view.searchAddresses()

            XCTAssertEqual(provider.searchCount, 1)
            XCTAssertEqual(provider.latestPostcode, "N7 9FU")

            XCTAssertNil(view.errorMessage)
            XCTAssert(view.addresses?.isEmpty == false)
            XCTAssertNil(view.state.selectedAddress)
        }
    }

    func testAddressSelectionEnablesNextButton() throws {
        let (_, _, view) = try addressDetailsView(result: .success([.stub]))

        XCTAssertView(view) { view in
            view.searchAddresses()
            view.state.selectedAddress = .stub
            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsAddressDetailsInContext() throws {
        let (context, _, view) = try addressDetailsView(result: .success([.stub]))

        XCTAssertView(view) { view in
            view.searchAddresses()
            view.state.selectedAddress = .stub
            view.nextButtonAction?()
            XCTAssertEqual(context.address, .stub)
        }
    }
}
