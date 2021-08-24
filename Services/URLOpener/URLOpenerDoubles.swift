import FoundationEncore

final class URLOpenerSpy: URLOpener {
    private(set) var openCount = 0
    private(set) var canOpenCount = 0

    var canOpenURLs: Bool

    init(canOpenURLs: Bool = true) {
        self.canOpenURLs = canOpenURLs
    }

    func open(_ url: URL) {
        openCount += 1
    }

    func canOpenURL(_ url: URL) -> Bool {
        canOpenCount += 1
        return canOpenURLs
    }
}

final class URLOpenerDummy: URLOpener {
    func open(_ url: URL) {}
    func canOpenURL(_ url: URL) -> Bool { true }
}
