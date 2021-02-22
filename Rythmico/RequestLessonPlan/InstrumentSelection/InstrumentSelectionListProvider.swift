import Foundation
import FoundationSugar

protocol InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>)
}

final class InstrumentSelectionListProvider: InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>) {
        completion(Instrument.allCases)
    }
}
