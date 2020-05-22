import Foundation

final class URLOpenerSpy: URLOpener {
    var openCount = 0

    init() {}

    func open(_ url: URL) {
        openCount += 1
    }
}
