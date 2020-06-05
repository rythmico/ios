import Foundation

final class URLOpenerSpy: URLOpener {
    var openCount = 0

    func open(_ url: URL) {
        openCount += 1
    }
}
