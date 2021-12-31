import APIKit
import CoreDTO
import FoundationEncore

struct GetAvailableInstrumentsRequest: APIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/instruments"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = [Instrument]
}
