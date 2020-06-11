import Foundation
import Sugar

protocol InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>)
}

final class InstrumentSelectionListProvider: InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>) {
        completion(Instrument.allCases)
    }
}
