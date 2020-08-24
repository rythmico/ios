import Foundation
import Sugar

struct Address: Hashable, Equatable, Codable {
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

extension Address {
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
