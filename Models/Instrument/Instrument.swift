import FoundationEncore
import struct SwiftUI.Image

enum Instrument: String, Equatable, Codable, CaseIterable, Hashable {
    case guitar = "GUITAR"
    case drums = "DRUMS"
    case piano = "PIANO"
    case singing = "SINGING"
    case bassGuitar = "BASS_GUITAR"
    case saxophone = "SAXOPHONE"
    case trumpet = "TRUMPET"
    case flute = "FLUTE"
    case violin = "VIOLIN"
    case harp = "HARP"
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
        case .bassGuitar:
            return "Bass Guitar"
        case .saxophone:
            return "Saxophone"
        case .trumpet:
            return "Trumpet"
        case .flute:
            return "Flute"
        case .violin:
            return "Violin"
        case .harp:
            return "Harp"
        }
    }

    /// Noun to be joined with other nouns.
    /// i.e. "Drum lessons", "Drum tutor".
    var assimilatedName: String {
        switch self {
        case .guitar,
             .piano,
             .singing,
             .bassGuitar,
             .saxophone,
             .trumpet,
             .flute,
             .violin,
             .harp:
            return standaloneName
        case .drums:
            return "Drum"
        }
    }
}
