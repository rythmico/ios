import Foundation
import struct SwiftUI.Image

enum Instrument: String, Equatable, Codable, CaseIterable {
    case guitar = "GUITAR"
    case drums = "DRUMS"
    case piano = "PIANO"
    case singing = "SINGING"
}

extension Instrument: Identifiable {
    var id: String { rawValue }
}

extension Instrument {
    var name: String {
        switch self {
        case .guitar:
            return "Guitar"
        case .drums:
            return "Drums"
        case .piano:
            return "Piano"
        case .singing:
            return "Singing"
        }
    }

    var icon: Image {
        switch self {
        case .guitar:
            return Image(decorative: Asset.instrumentIconGuitar.name)
        case .drums:
            return Image(decorative: Asset.instrumentIconDrums.name)
        case .piano:
            return Image(decorative: Asset.instrumentIconPiano.name)
        case .singing:
            return Image(decorative: Asset.instrumentIconSinging.name)
        }
    }
}
