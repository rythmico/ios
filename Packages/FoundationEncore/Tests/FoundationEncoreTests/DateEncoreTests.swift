import XCTest
import FoundationEncore

final class DateEncoreTests: XCTestCase {
    func testReferenceDate() {
        assert(.referenceDate, "2001-01-01T00:00:00Z")
    }

    func testSet() {
        assert(.referenceDate => ([], 0), "2001-01-01T00:00:00Z")
        assert(.referenceDate => (.day, 5), "2001-01-05T00:00:00Z")
        assert(.referenceDate => (.hour, 1), "2001-01-01T01:00:00Z")
        assert(.referenceDate => ([.hour, .minute, .second], 1), "2001-01-01T01:01:01Z")
        assert(.referenceDate => (.day, 5) => ([.hour, .minute, .second], 1), "2001-01-05T01:01:01Z")
        assert(.referenceDate => ([.hour, .minute, .second], 5) => (.day, 5), "2001-01-05T05:05:05Z")
    }

    func testSetWithTimeZone() {
        let timeZone = TimeZone(abbreviation: "BST")!
        let date: Date = "2021-08-26T03:25:50Z"
        assert(date => ([], 0, timeZone), "2021-08-26T03:25:50Z")
        assert(date => (.day, 5, timeZone), "2021-08-05T03:25:50Z")
        assert(date => (.hour, 1, timeZone), "2021-08-26T00:25:50Z")
        assert(date => ([.hour, .minute, .second], 1, timeZone), "2021-08-26T00:01:01Z")
        assert(date => (.day, 5, timeZone) => ([.hour, .minute, .second], 1, timeZone), "2021-08-05T00:01:01Z")
        assert(date => ([.hour, .minute, .second], 5, timeZone) => (.day, 5, timeZone), "2021-08-05T04:05:05Z")
    }

    func testSum() {
        assert(.referenceDate + (3, .year), "2004-01-01T00:00:00Z")
        assert(.referenceDate + (3, .year) + (50, .day), "2004-02-20T00:00:00Z")
        assert(.referenceDate - (3, .year) - (3, .day), "1997-12-29T00:00:00Z")
        assert(.referenceDate - (3, .year) - (3, .day) + (5, .hour), "1997-12-29T05:00:00Z")
    }

    func testInitDateTime() {
        let date: Date = "2021-07-03T19:32:13Z"
        let time: Date = "2005-02-28T17:25:30Z"
        assert(Date(date: date, time: time), "2021-07-03T17:25:30Z")
    }
}

private extension DateEncoreTests {
    func assert(_ date: Date, _ string: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(ISO8601DateFormatter.neutral.string(from: date), string, file: file, line: line)
    }
}
