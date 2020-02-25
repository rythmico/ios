import Foundation
import Sugar
import struct SwiftUI.Image

final class InstrumentSelectionListProviderFake: InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>) {
        let instruments = [
            Instrument(id: "GUITAR", name: "Guitar", icon: Image(decorative: Asset.instrumentIconGuitar.name)),
            Instrument(id: "DRUMS", name: "Drums", icon: Image(decorative: Asset.instrumentIconDrums.name)),
            Instrument(id: "PIANO", name: "Piano", icon: Image(decorative: Asset.instrumentIconPiano.name)),
            Instrument(id: "SINGING", name: "Singing", icon: Image(decorative: Asset.instrumentIconSinging.name))
        ]
        completion(instruments)
    }
}

final class InstrumentSelectionListProviderStub: InstrumentSelectionListProviderProtocol {
    var instruments: [Instrument]

    init(instruments: [Instrument]) {
        self.instruments = instruments
    }

    func instruments(completion: Handler<[Instrument]>) {
        completion(instruments)
    }
}
