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
        }
    }
}
