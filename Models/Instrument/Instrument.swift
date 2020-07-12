import Foundation
import struct SwiftUI.Image

enum Instrument: String, Equatable, Codable, CaseIterable, Hashable {
    case guitar = "GUITAR"
    case drums = "DRUMS"
    case piano = "PIANO"
    case singing = "SINGING"
}

extension Instrument: Identifiable {
    var id: String { rawValue }
}
