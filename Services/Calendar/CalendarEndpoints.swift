import APIKit

struct GetCalendarInfoRequest: RythmicoAPIRequest, EmptyInitProtocol {
    let method: HTTPMethod = .get
    let path: String = "/calendar"
    var headerFields: [String: String] = [:]
    let body: Void = ()

    typealias Response = CalendarInfo
}
