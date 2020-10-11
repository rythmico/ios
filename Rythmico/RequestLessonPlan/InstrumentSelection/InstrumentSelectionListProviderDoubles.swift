import Foundation
import Sugar

final class InstrumentSelectionListProviderStub: InstrumentSelectionListProviderProtocol {
    var instruments: [Instrument]

    init(instruments: [Instrument]) {
        self.instruments = instruments
    }

    func instruments(completion: Handler<[Instrument]>) {
        completion(instruments)
    }
}

final class InstrumentSelectionListProviderDummy: InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>) {}
}
