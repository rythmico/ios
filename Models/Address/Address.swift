import CoreDTO
import FoundationEncore

struct Address: AddressProtocol, Hashable, Equatable, Codable {
    var latitude: Double
    var longitude: Double
    var line1: String
    var line2: String
    var line3: String
    var line4: String
    var district: String
    var city: String
    var state: String
    var postcode: String
    var country: String
}

extension Address: Identifiable {
    var id: Int { hashValue }
}
