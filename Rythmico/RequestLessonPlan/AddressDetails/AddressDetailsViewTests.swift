import SwiftUIEncore
import XCTest
@testable import Rythmico
import ViewInspector

extension AddressDetailsView: Inspectable {}

final class AddressDetailsViewTests: XCTestCase {
    override func setUp() {
        Current = .dummy
        Current.userAuthenticated()
    }

    func addressDetailsView(
        result: Result<AddressSearchRequest.Response, Error>
    ) throws -> (
        RequestLessonPlanFlow,
        APIServiceSpy<AddressSearchRequest>,
        AddressDetailsView
    ) {
        let addressSearchService = APIServiceSpy<AddressSearchRequest>(result: result)
        Current.stubAPIEndpoint(for: \.addressSearchCoordinator, service: addressSearchService)
        let flow = RequestLessonPlanFlow()
        return (
            flow,
            addressSearchService,
            AddressDetailsView(
                student: .davidStub,
                instrument: .stub(.guitar),
                state: .init(),
                coordinator: Current.addressSearchCoordinator(),
                setter: { flow.address = $0 }
            )
        )
    }

    func testInitialValues() throws {
        let (flow, _, view) = try addressDetailsView(result: .success(.stub))

        try XCTAssertView(view) { view in
            XCTAssertNil(flow.address)

            try XCTAssertText(view.subtitle, "Enter the address where David will have the Guitar lessons")
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

            XCTAssertEqual(view.error?.legibleLocalizedDescription, "Something")
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

            XCTAssertEqual(view.error?.legibleLocalizedDescription, "Postcode must not be empty")
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
        let (flow, _, view) = try addressDetailsView(result: .success(.stub))

        XCTAssertView(view) { view in
            view.searchAddresses()
            view.state.selectedAddress = .stub
            view.nextButtonAction?()
            XCTAssertEqual(flow.address, .stub)
        }
    }
}
