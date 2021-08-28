import XCTest
import AnyEquatable

final class AnyEquatableTests: XCTestCase {
    func testBuiltInStructs() {
        assertEqual("string", "string")
        assertEqual(123, 123)
        assertEqual(false, false)

        assertNotEqual("string", 123)
        assertNotEqual(123, true)
        assertNotEqual(true, false)
    }

    func testEquatableStructs() {
        assertEqual(
            EquatableStruct(string: "string", number: 123, bool: false),
            EquatableStruct(string: "string", number: 123, bool: false)
        )

        assertNotEqual(
            EquatableStruct(string: "string", number: 123, bool: false),
            EquatableStruct(string: "string", number: 123, bool: true)
        )
        assertNotEqual(
            EquatableStruct(string: "string", number: 123, bool: false),
            "string"
        )
    }

    func testEquatableClasses() {
        assertEqual(
            EquatableClass(string: "string", number: 123, bool: false),
            EquatableClass(string: "string", number: 123, bool: false)
        )

        assertNotEqual(
            EquatableClass(string: "string", number: 123, bool: false),
            EquatableClass(string: "string", number: 123, bool: true)
        )
        assertNotEqual(
            EquatableClass(string: "string", number: 123, bool: false),
            "string" as NSString
        )
    }
}

private extension AnyEquatableTests {
    func assertEqual<LHS: Equatable, RHS: Equatable>(_ lhs: LHS, _ rhs: RHS, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(AnyEquatable(lhs), AnyEquatable(rhs), file: file, line: line)
    }

    func assertNotEqual<LHS: Equatable, RHS: Equatable>(_ lhs: LHS, _ rhs: RHS, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertNotEqual(AnyEquatable(lhs), AnyEquatable(rhs), file: file, line: line)
    }
}

private extension AnyEquatableTests {
    struct EquatableStruct: Equatable {
        var string: String
        var number: Int
        var bool: Bool
    }

    final class EquatableClass: Equatable {
        let string: String
        let number: Int
        let bool: Bool

        init(string: String, number: Int, bool: Bool) {
            self.string = string
            self.number = number
            self.bool = bool
        }

        static func == (lhs: EquatableClass, rhs: EquatableClass) -> Bool {
            lhs.string == rhs.string &&
            lhs.number == rhs.number &&
            lhs.bool == rhs.bool
        }
    }
}
