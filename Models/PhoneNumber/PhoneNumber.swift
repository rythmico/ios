import Foundation
import PhoneNumberKit

@propertyWrapper
struct E164PhoneNumber {
    var wrappedValue: PhoneNumber
}

extension E164PhoneNumber: Codable {
    init(e164Value: String) throws {
        self.init(wrappedValue: try PhoneNumberKit().parse(e164Value, ignoreType: true))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let e164Value = try container.decode(String.self)
        try self.init(e164Value: e164Value)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let e164Value = PhoneNumberKit().format(wrappedValue, toType: .e164)
        try container.encode(e164Value)
    }
}

@propertyWrapper
struct E164PhoneNumberOptional {
    var wrappedValue: PhoneNumber?
}

extension E164PhoneNumberOptional: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let e164Value = try? container.decode(String.self)
        self.init(wrappedValue: try e164Value.map(E164PhoneNumber.init)?.wrappedValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let e164Value = wrappedValue.map(E164PhoneNumber.init)
        try container.encode(e164Value)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: E164PhoneNumberOptional.Type, forKey key: Self.Key) throws -> E164PhoneNumberOptional {
        try decodeIfPresent(type, forKey: key) ?? E164PhoneNumberOptional(wrappedValue: nil)
    }
}
