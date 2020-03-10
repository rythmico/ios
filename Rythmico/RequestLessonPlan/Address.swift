import Foundation

struct Address {
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

extension Address {
    var fullString: String {
        [
            line1,
            line2,
            line3,
            line4,
            city,
            postcode,
            country,
        ].filter(\.isEmpty.not).joined(separator: "\n")
    }
}
