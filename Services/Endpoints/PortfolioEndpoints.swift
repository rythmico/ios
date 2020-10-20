import APIKit

struct GetPortfolioRequest: RythmicoAPIRequest {
    struct Body: Encodable {
        var tutorId: LessonPlan.Tutor.ID
    }

    let accessToken: String
    let properties: Body

    let method: HTTPMethod = .get
    var path: String { "/portfolios/\(self.tutorId)" }

    typealias Response = Portfolio
    typealias Error = RythmicoAPIError
}
