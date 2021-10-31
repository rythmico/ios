import CoreDTO
import SwiftUIEncore

extension Instrument {
    var icon: UIImage {
        switch id {
        case .known(let knownID):
            switch knownID {
            case .guitar:
                return Asset.Graphic.Instrument.guitar.image
            case .drums:
                return Asset.Graphic.Instrument.drums.image
            case .piano:
                return Asset.Graphic.Instrument.piano.image
            case .singing:
                return Asset.Graphic.Instrument.singing.image
            case .bassGuitar:
                return Asset.Graphic.Instrument.bassGuitar.image
            case .saxophone:
                return Asset.Graphic.Instrument.saxophone.image
            case .trumpet:
                return Asset.Graphic.Instrument.trumpet.image
            case .flute:
                return Asset.Graphic.Instrument.flute.image
            case .violin:
                return Asset.Graphic.Instrument.violin.image
            case .harp:
                return Asset.Graphic.Instrument.harp.image
            }
        case .unknown:
            return .genericInstrument
        }
    }
}
