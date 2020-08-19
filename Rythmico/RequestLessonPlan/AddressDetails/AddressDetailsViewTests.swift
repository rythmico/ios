import XCTest
import SwiftUI
import Sugar
@testable import Rythmico
import ViewInspector

extension AddressDetailsView: Inspectable {}

final class AddressDetailsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func addressDetailsView(
        result: SimpleResult<AddressSearchRequest.Response>
    ) throws -> (
        RequestLessonPlanContext,
        APIServiceSpy<AddressSearchRequest>,
        AddressDetailsView
    ) {
        let addressSearchService = APIServiceSpy<AddressSearchRequest>(result: result)
        Current.addressSearchService = addressSearchService
        let context = RequestLessonPlanContext()
        return try (
            context,
            addressSearchService,
            AddressDetailsView(
                student: .davidStub,
                instrument: .guitar,
                state: .init(),
                searchCoordinator: XCTUnwrap(Current.coordinator(for: \.addressSearchService)),
                context: context
            )
        )
    }

    func testInitialValues() throws {
        let (context, _, view) = try addressDetailsView(result: .success(.stub))

        XCTAssertView(view) { view in
            XCTAssertNil(context.address)

            XCTAssertEqual(view.subtitle.string, "Enter the address where David will have the Guitar lessons")
            XCTAssertTrue(view.state.postcode.isEmpty)
            XCTAssertNil(view.state.selectedAddress)

            XCTAssertNil(view.addresses)
            XCTAssertFalse(view.isLoading)
            XCTAssertNil(view.error)
            XCTAssertNil(view.nextButtonAction)
        }
    }

    func testSearchAddresses_failure() throws {
        let (_, provider, view) = try addressDetailsView(result: .failure("Something"))

        XCTAssertView(view) { view in
            view.state.postcode = "N7"
            view.searchAddresses()

            XCTAssertEqual(provider.sendCount, 1)
            XCTAssertEqual(provider.latestRequest?.postcode, "n7")

            XCTAssertEqual(view.error?.localizedDescription, "Something")
            XCTAssertNil(view.addresses)
            XCTAssertNil(view.state.selectedAddress)
        }
    }

    func testSearchAddressesWithEmptyPostcode_failure() throws {
        let (_, provider, view) = try addressDetailsView(result: .failure("Something"))

        XCTAssertView(view) { view in
            view.state.postcode = "N7"
            view.state.postcode = ""
            view.searchAddresses()

            XCTAssertEqual(provider.sendCount, 0)
            XCTAssertNil(provider.latestRequest?.postcode)

            XCTAssertEqual(view.error?.localizedDescription, "Postcode must not be empty")
            XCTAssertNil(view.addresses)
            XCTAssertNil(view.state.selectedAddress)
        }
    }

    func testSearchAddresses_success() throws {
        let (_, provider, view) = try addressDetailsView(result: .success(.stub))

        XCTAssertView(view) { view in
            view.state.postcode = "N7"
            view.state.postcode = "N7 9FU"
            view.searchAddresses()

            XCTAssertEqual(provider.sendCount, 1)
            XCTAssertEqual(provider.latestRequest?.postcode, "n79fu")

            XCTAssertNil(view.error)
            XCTAssert(view.addresses?.isEmpty == false)
            XCTAssertNil(view.state.selectedAddress)
        }
    }

    func testAddressSelectionEnablesNextButton() throws {
        let (_, _, view) = try addressDetailsView(result: .success(.stub))

        XCTAssertView(view) { view in
            view.searchAddresses()
            view.state.selectedAddress = .stub
            XCTAssertNotNil(view.nextButtonAction)
        }
    }

    func testNextButtonSetsAddressDetailsInContext() throws {
        let (context, _, view) = try addressDetailsView(result: .success(.stub))

        XCTAssertView(view) { view in
            view.searchAddresses()
            view.state.selectedAddress = .stub
            view.nextButtonAction?()
            XCTAssertEqual(context.address, .stub)
        }
    }
}
