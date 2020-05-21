import Foundation
import Sugar

struct Address: AddressDetailsProtocol, Hashable, Equatable, Codable {
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
}
