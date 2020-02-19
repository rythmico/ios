import Foundation
import Sugar
import struct SwiftUI.Image

final class InstrumentProviderFake: InstrumentProviderProtocol {
    func instruments(completion: Handler<[Instrument]>) {
        let instruments = [
            Instrument(id: "GUITAR", name: "Guitar", icon: Image(decorative: "instrument-icon-guitar")),
            Instrument(id: "DRUMS", name: "Drums", icon: Image(decorative: "instrument-icon-drums")),
            Instrument(id: "PIANO", name: "Piano", icon: Image(decorative: "instrument-icon-piano")),
            Instrument(id: "SINGING", name: "Singing", icon: Image(decorative: "instrument-icon-singing"))
        ]
        completion(instruments)
    }
}

final class InstrumentProviderStub: InstrumentProviderProtocol {
    var instruments: [Instrument]

    init(instruments: [Instrument]) {
        self.instruments = instruments
    }

    func instruments(completion: Handler<[Instrument]>) {
        completion(instruments)
    }
}
