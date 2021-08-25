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
        let date = .referenceDate => (.year, 2021) => (.month, 7) => (.day, 3)
        let time = .referenceDate => (.hour, 17) => (.minute, 25) => (.second, 30)
        assert(.init(date: date, time: time), "2021-07-03T17:25:30Z")
    }
}

private extension Date_SugarTests {
    var formatter: ISO8601DateFormatter { .init() => (\.timeZone, .neutral) }

    func assert(_ date: Date, _ string: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(formatter.string(from: date), string, file: file, line: line)
    }
}
