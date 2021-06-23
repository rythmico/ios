import FoundationSugar
import struct SwiftUI.Image

enum Instrument: String, Equatable, Codable, CaseIterable, Hashable {
    case guitar = "GUITAR"
    case drums = "DRUMS"
    case piano = "PIANO"
    case singing = "SINGING"
    case saxophone = "SAXOPHONE"
    case trumpet = "TRUMPET"
    case flute = "FLUTE"
    case violin = "VIOLIN"
}

extension Instrument: Identifiable {
    var id: String { rawValue }
}

extension Instrument {
    var standaloneName: String {
        switch self {
        case .guitar:
            return "Guitar"
        case .drums:
            return "Drums"
        case .piano:
            return "Piano"
        case .singing:
            return "Singing"
        case .saxophone:
            return "Saxophone"
        case .trumpet:
            return "Trumpet"
        case .flute:
            return "Flute"
        case .violin:
            return "Violin"
        }
    }

    /// Noun to be joined with other nouns.
    /// i.e. "Drum lessons", "Drum tutor".
    var assimilatedName: String {
        switch self {
        case .guitar, .piano, .singing, .saxophone, .trumpet, .flute, .violin:
            return standaloneName
        case .drums:
            return "Drum"
        }
    }
}
