import Foundation
import Sugar

protocol InstrumentSelectionListProviderProtocol {
    func instruments(completion: Handler<[Instrument]>)
}
