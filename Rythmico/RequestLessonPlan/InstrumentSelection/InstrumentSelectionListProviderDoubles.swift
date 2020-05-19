import Foundation
import Sugar
import struct SwiftUI.Image

final class InstrumentSelectionListProviderFake: InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>) {
        completion(Instrument.allCases)
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
