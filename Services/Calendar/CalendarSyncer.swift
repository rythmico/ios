import FoundationEncore

private enum Const {
    #if LIVE
    static let host = "rythmico-prod.web.app"
    #else
    static let host = "rythmico-dev.web.app"
    #endif
}

extension URLOpener {
    func subscribeToCalendar(with info: CalendarInfo) throws {
        open(try URL(scheme: "webcal", host: Const.host, path: "/calendar/" + info.token))
    }
}
