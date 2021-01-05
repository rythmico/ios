import Foundation

private enum Const {
    #if DEBUG
    static let host = "rythmico-dev.web.app"
    #else
    static let host = "rythmico-prod.web.app"
    #endif
}

extension URLOpener {
    func subscribeToCalendar(with info: CalendarInfo) throws {
        open(try URL(scheme: "webcal", host: Const.host, path: "/calendar/" + info.token))
    }
}
