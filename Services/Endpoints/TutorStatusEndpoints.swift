import APIKit

struct GetTutorStatusRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/tutor-status"

    typealias Response = TutorStatus
    typealias Error = RythmicoAPIError
}
