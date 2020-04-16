import Foundation
import Sugar

struct Address: Equatable, Identifiable {
    var id: String
    var latitude: Double
    var longitude: Double
    var line1: String
    var line2: String
    var line3: String
    var line4: String
    var city: String
    var postcode: String
    var country: String

    init(
        id: String? = nil,
        latitude: Double,
        longitude: Double,
        line1: String,
        line2: String,
        line3: String,
        line4: String,
        city: String,
        postcode: String,
        country: String
    ) {
        if let id = id {
            self.id = id
        } else {
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
            self.id = String(hasher.finalize())
        }
        self.latitude = latitude
        self.longitude = longitude
        self.line1 = line1
        self.line2 = line2
        self.line3 = line3
        self.line4 = line4
        self.city = city
        self.postcode = postcode
        self.country = country
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
