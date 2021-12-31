import FoundationEncore
import TutorDO
import XCTest

final class AddressTests: XCTestCase {
    struct AddressMock: AddressProtocol {
        var latitude: Double
        var longitude: Double
        var line1: String
        var line2: String
        var line3: String
        var line4: String
        var district: String
        var city: String
        var state: String
        var postcode: String
        var country: String
    }

    func testFormatted_multilineCompactStyle() {
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "",
                line3: "",
                line4: "",
                district: "District",
                city: "City",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multilineCompact),
            """
            Line 1
            City, Post code
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "",
                line4: "",
                district: "District",
                city: "City",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multilineCompact),
            """
            Line 1, Line 2
            City, Post code
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "Line 3",
                line4: "",
                district: "District",
                city: "City",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multilineCompact),
            """
            Line 1, Line 2
            Line 3
            City, Post code
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "Line 3",
                line4: "Line 4",
                district: "District",
                city: "",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multilineCompact),
            """
            Line 1, Line 2
            Line 3, Line 4
            Post code
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "Line 3",
                line4: "Line 4",
                district: "District",
                city: "City",
                state: "State",
                postcode: "",
                country: "Country"
            ).formatted(style: .multilineCompact),
            """
            Line 1, Line 2
            Line 3, Line 4
            City
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "Line 3",
                line4: "Line 4",
                district: "District",
                city: "City",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multilineCompact),
            """
            Line 1, Line 2
            Line 3, Line 4
            City, Post code
            """
        )
    }

    func testFormatted_multilineStyle() {
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "",
                line3: "",
                line4: "",
                district: "District",
                city: "City",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multiline),
            """
            Line 1
            City
            Post code
            Country
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "",
                line4: "",
                district: "District",
                city: "City",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multiline),
            """
            Line 1
            Line 2
            City
            Post code
            Country
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "Line 3",
                line4: "",
                district: "District",
                city: "City",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multiline),
            """
            Line 1
            Line 2
            Line 3
            City
            Post code
            Country
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "Line 3",
                line4: "Line 4",
                district: "District",
                city: "",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multiline),
            """
            Line 1
            Line 2
            Line 3
            Line 4
            Post code
            Country
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "Line 3",
                line4: "Line 4",
                district: "District",
                city: "City",
                state: "State",
                postcode: "",
                country: "Country"
            ).formatted(style: .multiline),
            """
            Line 1
            Line 2
            Line 3
            Line 4
            City
            Country
            """
        )
        XCTAssertNoDifference(
            AddressMock(
                latitude: 0,
                longitude: 0,
                line1: "Line 1",
                line2: "Line 2",
                line3: "Line 3",
                line4: "Line 4",
                district: "District",
                city: "City",
                state: "State",
                postcode: "Post code",
                country: "Country"
            ).formatted(style: .multiline),
            """
            Line 1
            Line 2
            Line 3
            Line 4
            City
            Post code
            Country
            """
        )
    }
}
