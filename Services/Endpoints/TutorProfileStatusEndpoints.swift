import APIKit
import TutorDO

struct GetTutorProfileStatusRequest: APIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/tutor/profile-status"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = TutorDTO.ProfileStatus
}
