import Foundation
import Sugar

struct Address: Equatable {
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
    var id: Int {
        var hasher = Hasher()
        hasher.combine(latitude)
        hasher.combine(longitude)
        hasher.combine(line1)
        hasher.combine(line2)
        hasher.combine(line3)
        hasher.combine(line4)
        hasher.combine(city)
        hasher.combine(postcode)
        hasher.combine(country)
        return hasher.finalize()
    }
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
        ].filter(\.isEmpty.not).joined(separator: .newline)
    }

    var singleLineFormattedString: String {
        [
            line1,
            line2,
            line3,
            line4,
            city,
            postcode,
            country,
        ].filter(\.isEmpty.not).joined(separator: .comma + .whitespace)
    }
}
