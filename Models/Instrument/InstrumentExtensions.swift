import SwiftUI

extension Instrument {
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

    var largeIcon: Image {
        switch self {
        case .guitar:
            return Image(decorative: Asset.instrumentIconGuitarLarge.name)
        case .drums:
            return Image(decorative: Asset.instrumentIconDrumsLarge.name)
        case .piano:
            return Image(decorative: Asset.instrumentIconPianoLarge.name)
        case .singing:
            return Image(decorative: Asset.instrumentIconSingingLarge.name)
        }
    }
}
