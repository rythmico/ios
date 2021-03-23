import XCTest
import FoundationSugar
import Then

final class Date_SugarTests: XCTestCase {
    func testReferenceDate() {
        assert(.referenceDate, "2001-01-01T00:00:00Z")
    }

    func testSet() {
        assert(.referenceDate <- (5, .day, calendar), "2001-01-05T00:00:00Z")
        assert(.referenceDate <- (1, .hour, calendar), "2001-01-01T01:00:00Z")
        assert(.referenceDate <- (1, [.hour, .minute, .second], calendar), "2001-01-01T01:01:01Z")
        // FIXME
        // assert(.referenceDate <- (1, [.hour, .minute, .second], calendar) <- (5, .day, calendar), "2001-01-05T01:01:01Z")
    }

    func testSum() {
        assert(.referenceDate + (3, .year, calendar), "2004-01-01T00:00:00Z")
        assert(.referenceDate + (3, .year, calendar) + (50, .day, calendar), "2004-02-20T00:00:00Z")
        assert(.referenceDate - (3, .year, calendar) - (3, .day, calendar), "1997-12-29T00:00:00Z")
        assert(.referenceDate - (3, .year, calendar) - (3, .day, calendar) + (5, .hour, calendar), "1997-12-29T05:00:00Z")
    }

    func testInitDateTime() {
        let date = .referenceDate <- (2021, .year, calendar) <- (7, .month, calendar) <- (3, .day, calendar)
        let time = .referenceDate <- (17, .hour, calendar) <- (25, .minute, calendar) <- (30, .second, calendar)
        assert(.init(date: date, time: time, calendar: calendar), "2021-07-03T17:25:30Z")
    }
}

private extension Date_SugarTests {
    var timeZone: TimeZone { .init(identifier: "GMT")! }
    var calendar: Calendar { .init(identifier: .gregorian).with(\.timeZone, timeZone) }
    var formatter: ISO8601DateFormatter { .init().with(\.timeZone, timeZone) }

    func assert(_ date: Date, _ string: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(formatter.string(from: date), string, file: file, line: line)
    }
}
