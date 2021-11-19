import TutorDO
import XCTest

final class LessonPlanRequestPartialAddressTests: XCTestCase {
    func testFormatted_singleLineStyle() {
        XCTAssertEqual(
            LessonPlanRequestPartialAddress(
                latitude: 123,
                longitude: 456,
                district: "",
                districtCode: ""
            ).formatted(style: .singleLine),
            ""
        )
        XCTAssertEqual(
            LessonPlanRequestPartialAddress(
                latitude: 123,
                longitude: 456,
                district: "Haringey",
                districtCode: ""
            ).formatted(style: .singleLine),
            "Haringey"
        )
        XCTAssertEqual(
            LessonPlanRequestPartialAddress(
                latitude: 123,
                longitude: 456,
                district: "Haringey",
                districtCode: "N8"
            ).formatted(style: .singleLine),
            "Haringey, N8"
        )
        XCTAssertEqual(
            LessonPlanRequestPartialAddress(
                latitude: 123,
                longitude: 456,
                district: "",
                districtCode: "N8"
            ).formatted(style: .singleLine),
            "N8"
        )
    }

    func testFormatted_multilineStyle() {
        XCTAssertEqual(
            LessonPlanRequestPartialAddress(
                latitude: 123,
                longitude: 456,
                district: "",
                districtCode: ""
            ).formatted(style: .multiline),
            ""
        )
        XCTAssertEqual(
            LessonPlanRequestPartialAddress(
                latitude: 123,
                longitude: 456,
                district: "Haringey",
                districtCode: ""
            ).formatted(style: .multiline),
            "Haringey"
        )
        XCTAssertEqual(
            LessonPlanRequestPartialAddress(
                latitude: 123,
                longitude: 456,
                district: "Haringey",
                districtCode: "N8"
            ).formatted(style: .multiline),
            """
            Haringey
            N8
            """
        )
        XCTAssertEqual(
            LessonPlanRequestPartialAddress(
                latitude: 123,
                longitude: 456,
                district: "",
                districtCode: "N8"
            ).formatted(style: .multiline),
            "N8"
        )
    }
}
