import APIKit

struct GetPortfolioRequest: APIRequest {
    var tutorId: Tutor.ID

    let method: HTTPMethod = .get
    var path: String { "/portfolios/\(tutorId)" }
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = Portfolio
}
