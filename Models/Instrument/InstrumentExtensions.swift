import SwiftUI

extension Instrument {
    var icon: ImageAsset {
        switch self {
        case .guitar:
            return Asset.instrumentIconGuitar
        case .drums:
            return Asset.instrumentIconDrums
        case .piano:
            return Asset.instrumentIconPiano
        case .singing:
            return Asset.instrumentIconSinging
        case .saxophone:
            return Asset.instrumentIconSaxophone
        case .trumpet:
            return Asset.instrumentIconTrumpet
        case .flute:
            return Asset.instrumentIconFlute
        case .violin:
            return Asset.instrumentIconViolin
        }
    }
}
