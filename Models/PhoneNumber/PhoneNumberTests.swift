import XCTest
@testable import Rythmico
import PhoneNumberKit

final class PhoneNumberTests: XCTestCase {}

extension PhoneNumberTests {
    func testDecoding_UK() throws {
        let sut = try self.sutDecoded("+447402421160")
        XCTAssertEqual(sut.phoneNumber.numberString, "+447402421160")
        XCTAssertEqual(sut.phoneNumber.countryCode, 44)
        XCTAssertEqual(sut.phoneNumber.leadingZero, false)
        XCTAssertEqual(sut.phoneNumber.nationalNumber, 7402421160)
        XCTAssertEqual(sut.phoneNumber.numberExtension, nil)
        XCTAssertEqual(sut.phoneNumber.type, .unknown)
        XCTAssertEqual(sut.phoneNumber.regionID, "GB")
    }

    func testDecoding_ES() throws {
        let sut = try self.sutDecoded("+34644236696")
        XCTAssertEqual(sut.phoneNumber.numberString, "+34644236696")
        XCTAssertEqual(sut.phoneNumber.countryCode, 34)
        XCTAssertEqual(sut.phoneNumber.leadingZero, false)
        XCTAssertEqual(sut.phoneNumber.nationalNumber, 644236696)
        XCTAssertEqual(sut.phoneNumber.numberExtension, nil)
        XCTAssertEqual(sut.phoneNumber.type, .unknown)
        XCTAssertEqual(sut.phoneNumber.regionID, "ES")
    }

    func testDecoding_partial() throws {
        XCTAssertThrowsError(try self.sutDecoded("+3464423")) { error in
            switch error {
            case let error as PhoneNumberError where error == .notANumber:
                break
            default:
                XCTFail("Unexpected error received: \(error)")
            }
        }
    }

    func testDecoding_null() throws {
        XCTAssertThrowsError(try self.sutDecoded(nil)) { error in
            switch error {
            case _ as DecodingError:
                break
            default:
                XCTFail("Unexpected error received: \(error)")
            }
        }
    }

    func testDecoding_empty() throws {
        XCTAssertThrowsError(try self.sutDecodedEmpty()) { error in
            switch error {
            case _ as DecodingError:
                break
            default:
                XCTFail("Unexpected error received: \(error)")
            }
        }
    }
}

extension PhoneNumberTests {
    func testOptionalDecoding_UK() throws {
        let sut = try self.sutDecodedOptional("+447402421160")
        XCTAssertEqual(sut.phoneNumber?.numberString, "+447402421160")
        XCTAssertEqual(sut.phoneNumber?.countryCode, 44)
        XCTAssertEqual(sut.phoneNumber?.leadingZero, false)
        XCTAssertEqual(sut.phoneNumber?.nationalNumber, 7402421160)
        XCTAssertEqual(sut.phoneNumber?.numberExtension, nil)
        XCTAssertEqual(sut.phoneNumber?.type, .unknown)
        XCTAssertEqual(sut.phoneNumber?.regionID, "GB")
    }

    func testOptionalDecoding_ES() throws {
        let sut = try self.sutDecodedOptional("+34644236696")
        XCTAssertEqual(sut.phoneNumber?.numberString, "+34644236696")
        XCTAssertEqual(sut.phoneNumber?.countryCode, 34)
        XCTAssertEqual(sut.phoneNumber?.leadingZero, false)
        XCTAssertEqual(sut.phoneNumber?.nationalNumber, 644236696)
        XCTAssertEqual(sut.phoneNumber?.numberExtension, nil)
        XCTAssertEqual(sut.phoneNumber?.type, .unknown)
        XCTAssertEqual(sut.phoneNumber?.regionID, "ES")
    }

    func testOptionalDecoding_partial() throws {
        XCTAssertThrowsError(try self.sutDecodedOptional("+3464423")) { error in
            switch error {
            case let error as PhoneNumberError where error == .notANumber:
                break
            default:
                XCTFail("Unexpected error received: \(error)")
            }
        }
    }

    func testOptionalDecoding_null() throws {
        let sut = try self.sutDecodedOptional(nil)
        XCTAssertNil(sut.phoneNumber)
    }

    func testOptionalDecoding_empty() throws {
        let sut = try self.sutDecodedEmptyOptional()
        XCTAssertNil(sut.phoneNumber)
    }
}

extension PhoneNumberTests {
    func testEncoding_UK() throws {
        XCTAssertEqual(
            try sutEncoded("+447402421160"),
            """
            {"phoneNumber":"+447402421160"}
            """
        )
    }

    func testEncoding_ES() throws {
        XCTAssertEqual(
            try sutEncoded("+34644236696"),
            """
            {"phoneNumber":"+34644236696"}
            """
        )
    }
}

extension PhoneNumberTests {
    func testOptionalEncoding_UK() throws {
        XCTAssertEqual(
            try sutEncodedOptional("+447402421160"),
            """
            {"phoneNumber":"+447402421160"}
            """
        )
    }

    func testOptionalEncoding_ES() throws {
        XCTAssertEqual(
            try sutEncodedOptional("+34644236696"),
            """
            {"phoneNumber":"+34644236696"}
            """
        )
    }

    func testOptionalEncoding_null() throws {
        XCTAssertEqual(
            try sutEncodedOptional(nil),
            """
            {"phoneNumber":null}
            """
        )
    }
}

private extension PhoneNumberTests {
    struct CodableWithPhoneNumber: Codable {
        @E164PhoneNumber var phoneNumber: PhoneNumber
    }

    struct CodableWithPhoneNumberOptional: Codable {
        @E164PhoneNumberOptional var phoneNumber: PhoneNumber?
    }

    func sutDecoded(_ phoneNumber: String?) throws -> CodableWithPhoneNumber {
        try JSONDecoder().decode(CodableWithPhoneNumber.self, from: json(phoneNumber))
    }

    func sutDecodedOptional(_ phoneNumber: String?) throws -> CodableWithPhoneNumberOptional {
        try JSONDecoder().decode(CodableWithPhoneNumberOptional.self, from: json(phoneNumber))
    }

    func sutDecodedEmpty() throws -> CodableWithPhoneNumber {
        try JSONDecoder().decode(CodableWithPhoneNumber.self, from: jsonEmpty())
    }

    func sutDecodedEmptyOptional() throws -> CodableWithPhoneNumberOptional {
        try JSONDecoder().decode(CodableWithPhoneNumberOptional.self, from: jsonEmpty())
    }

    func sutEncoded(_ phoneNumber: String) throws -> String? {
        String(data: try JSONEncoder().encode(sutDecoded(phoneNumber)), encoding: .utf8)
    }

    func sutEncodedOptional(_ phoneNumber: String?) throws -> String? {
        String(data: try JSONEncoder().encode(sutDecodedOptional(phoneNumber)), encoding: .utf8)
    }

    func jsonEmpty() -> Data {
        Data("{}".utf8)
    }

    func json(_ phoneNumber: String?) -> Data {
        Data(
            """
            { "phoneNumber": \(phoneNumber.map { $0.quoted() } ?? "null") }
            """
            .utf8
        )
    }
}
