import APIKit

struct GetCalendarInfoRequest: RythmicoAPIRequest {
    let accessToken: String
    let properties: Void

    let method: HTTPMethod = .get
    let path: String = "/calendar"

    typealias Response = CalendarInfo
    typealias Error = RythmicoAPIError
}
