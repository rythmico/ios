import APIKit

struct GetCalendarInfoRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/calendar"
    var headerFields: [String: String] = [:]

    typealias Response = CalendarInfo
}
