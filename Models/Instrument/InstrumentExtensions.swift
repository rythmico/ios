import SwiftUI

extension Instrument {
    var icon: ImageAsset {
        switch self {
        case .guitar:
            return Asset.Graphic.Instrument.guitar
        case .drums:
            return Asset.Graphic.Instrument.drums
        case .piano:
            return Asset.Graphic.Instrument.piano
        case .singing:
            return Asset.Graphic.Instrument.singing
        case .saxophone:
            return Asset.Graphic.Instrument.saxophone
        case .trumpet:
            return Asset.Graphic.Instrument.trumpet
        case .flute:
            return Asset.Graphic.Instrument.flute
        case .violin:
            return Asset.Graphic.Instrument.violin
        }
    }
}
