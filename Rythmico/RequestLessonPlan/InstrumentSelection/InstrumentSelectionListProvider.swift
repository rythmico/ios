import FoundationEncore

protocol InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>)
}

final class InstrumentSelectionListProvider: InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>) {
        completion(Instrument.allCases)
    }
}
