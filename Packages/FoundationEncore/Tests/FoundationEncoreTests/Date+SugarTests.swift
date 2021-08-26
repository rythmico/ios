import XCTest
import FoundationEncore

final class Date_SugarTests: XCTestCase {
    func testReferenceDate() {
        assert(.referenceDate, "2001-01-01T00:00:00Z")
    }

    func testSet() {
        assert(.referenceDate => (.day, 5), "2001-01-05T00:00:00Z")
        assert(.referenceDate => (.hour, 1), "2001-01-01T01:00:00Z")
        assert(.referenceDate => ([.hour, .minute, .second], 1), "2001-01-01T01:01:01Z")
        assert(.referenceDate => (.day, 5) => ([.hour, .minute, .second], 1), "2001-01-05T01:01:01Z")
        assert(.referenceDate => ([.hour, .minute, .second], 5) => (.day, 5), "2001-01-05T05:05:05Z")
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

private extension Date_SugarTests {
    func assert(_ date: Date, _ string: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(ISO8601DateFormatter.neutral.string(from: date), string, file: file, line: line)
    }
}
