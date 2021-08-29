import XCTest
@testable import FoundationEncore

final class UserDefaultsEncoreTests: XCTestCase {
    let spy = UserDefaults.spy

    func testGetSetSingleNonOptionalProperty() {
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], [:])
        XCTAssertEqual(spy.propertyA, false)
        spy.propertyA = false
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyA": false])
        XCTAssertEqual(spy.propertyA, false)
        spy.propertyA = true
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyA": true])
        XCTAssertEqual(spy.propertyA, true)
    }

    func testGetSetSingleOptionalProperty() {
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], [:])
        XCTAssertEqual(spy.propertyB, nil)
        spy.propertyB = nil
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], [:])
        XCTAssertEqual(spy.propertyB, nil)
        spy.propertyB = false
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyB": false])
        XCTAssertEqual(spy.propertyB, false)
        spy.propertyB = true
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyB": true])
        XCTAssertEqual(spy.propertyB, true)
        spy.propertyB = nil
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], [:])
        XCTAssertEqual(spy.propertyB, nil)
    }

    func testGetSetMultipleProperties() {
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], [:])
        XCTAssertEqual(spy.propertyA, false)
        spy.propertyA = false
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyA": false])
        XCTAssertEqual(spy.propertyA, false)
        spy.propertyB = nil
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyA": false])
        XCTAssertEqual(spy.propertyA, false)
        XCTAssertEqual(spy.propertyB, nil)
        spy.propertyA = true
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyA": true])
        XCTAssertEqual(spy.propertyA, true)
        XCTAssertEqual(spy.propertyB, nil)
        spy.propertyB = false
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyA": true, "propertyB": false])
        XCTAssertEqual(spy.propertyA, true)
        XCTAssertEqual(spy.propertyB, false)
        spy.propertyB = true
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyA": true, "propertyB": true])
        XCTAssertEqual(spy.propertyA, true)
        XCTAssertEqual(spy.propertyB, true)
        spy.propertyB = nil
        XCTAssertEqual(spy.inMemoryDefaults as? [String: AnyHashable], ["propertyA": true])
        XCTAssertEqual(spy.propertyA, true)
        XCTAssertEqual(spy.propertyB, nil)
    }
}

extension UserDefaults {
    static var spy: UserDefaultsMock {
        UserDefaultsMock(
            get: { key, memory in memory[key] },
            set: { value, key, memory in memory[key] = value },
            remove: { key, memory in memory.removeValue(forKey: key) }
        )
    }
}

extension UserDefaults {
    var propertyA: Bool {
        get { get(default: false) }
        set { set(newValue) }
    }

    var propertyB: Bool? {
        get { get() }
        set { set(newValue) }
    }
}
