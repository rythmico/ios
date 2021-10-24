import CoreDTO
import FoundationEncore

struct Address: AddressProtocol, Hashable, Equatable, Codable {
    var latitude: Double
    var longitude: Double
    var line1: String
    var line2: String
    var line3: String
    var line4: String
    var city: String
    var postcode: String
    var country: String
}

extension Address: Identifiable {
    var id: Int { hashValue }
}

// TODO: use iOS 15's custom FormatStyles
// https://emptytheory.com/2021/08/14/creating-custom-parseable-format-styles-in-ios-15/

extension AddressProtocol {
    var multipleLineFormattedString: String {
        [
            line1,
            line2,
            line3,
            line4,
            city,
            postcode,
            country,
        ]
        .filter(\.isEmpty.not).joined(separator: .newline)
    }

    var condensedFormattedString: String {
        [
            [line1, line2],
            [line3, line4],
            [city, postcode]
        ]
        .map { $0.filter(\.isEmpty.not) }
        .filter(\.isEmpty.not)
        .map { $0.joined(separator: .comma + .whitespace) }
        .joined(separator: .newline)
    }
}
