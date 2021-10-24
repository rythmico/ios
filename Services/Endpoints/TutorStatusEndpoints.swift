import APIKit

struct GetTutorStatusRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/tutor-status"
    var headerFields: [String: String] = [:]

    typealias Response = TutorStatus
}
