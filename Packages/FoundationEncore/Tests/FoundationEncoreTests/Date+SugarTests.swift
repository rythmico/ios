import XCTest
import FoundationEncore

final class Date_SugarTests: XCTestCase {
    func testReferenceDate() {
        assert(.referenceDate, "2001-01-01T00:00:00Z")
    }

    func testSet() {
        assert(.referenceDate <- (5, .day), "2001-01-05T00:00:00Z")
        assert(.referenceDate <- (1, .hour), "2001-01-01T01:00:00Z")
        assert(.referenceDate <- (1, [.hour, .minute, .second]), "2001-01-01T01:01:01Z")
        // FIXME
//         assert(.referenceDate <- (1, [.hour, .minute, .second]) <- (5, .day), "2001-01-05T01:01:01Z")
    }

    func testSum() {
        assert(.referenceDate + (3, .year), "2004-01-01T00:00:00Z")
        assert(.referenceDate + (3, .year) + (50, .day), "2004-02-20T00:00:00Z")
        assert(.referenceDate - (3, .year) - (3, .day), "1997-12-29T00:00:00Z")
        assert(.referenceDate - (3, .year) - (3, .day) + (5, .hour), "1997-12-29T05:00:00Z")
    }

    func testInitDateTime() {
        let date = .referenceDate <- (2021, .year) <- (7, .month) <- (3, .day)
        let time = .referenceDate <- (17, .hour) <- (25, .minute) <- (30, .second)
        assert(.init(date: date, time: time), "2021-07-03T17:25:30Z")
    }
}

private extension Date_SugarTests {
    var formatter: ISO8601DateFormatter { .init().with(\.timeZone, .neutral) }

    func assert(_ date: Date, _ string: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(formatter.string(from: date), string, file: file, line: line)
    }
}
