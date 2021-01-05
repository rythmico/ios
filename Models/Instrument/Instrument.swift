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
        }
    }

    /// Noun to be joined with other nouns.
    /// i.e. "Drum lessons", "Drum tutor".
    var assimilatedName: String {
        switch self {
        case .guitar:
            return "Guitar"
        case .drums:
            return "Drum"
        case .piano:
            return "Piano"
        case .singing:
            return "Singing"
        }
    }
}
