import Foundation
import Sugar

protocol InstrumentProviderProtocol {
    func instruments(completion: Handler<[Instrument]>)
}
