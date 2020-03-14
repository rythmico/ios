import Foundation
import struct SwiftUI.Image

extension Instrument {
    static var guitarStub: Instrument {
        .init(
            id: "GUITAR",
            name: "Guitar",
            icon: Image(decorative: Asset.instrumentIconGuitar.name)
        )
    }

    static var drumsStub: Instrument {
        .init(
            id: "DRUMS",
            name: "Drums",
            icon: Image(decorative: Asset.instrumentIconDrums.name)
        )
    }

    static var pianoStub: Instrument {
        .init(
            id: "PIANO",
            name: "Piano",
            icon: Image(decorative: Asset.instrumentIconPiano.name)
        )
    }

    static var singingStub: Instrument {
        .init(
            id: "SINGING",
            name: "Singing",
            icon: Image(decorative: Asset.instrumentIconSinging.name)
        )
    }
}

extension Array where Element == Instrument {
    static var allInstrumentsStub: [Instrument] {
        [
            .guitarStub,
            .drumsStub,
            .pianoStub,
            .singingStub,
        ]
    }
}
