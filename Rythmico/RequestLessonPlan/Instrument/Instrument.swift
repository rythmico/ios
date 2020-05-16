import Foundation
import struct SwiftUI.Image

struct Instrument: Identifiable, Equatable, Encodable {
    var id: String
    var name: String
    var icon: Image

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(id)
    }
}
