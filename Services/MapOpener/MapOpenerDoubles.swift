#if DEBUG
import Foundation

final class MapOpenerSpy: MapOpenerProtocol {
    var openCount = 0

    func open(_ link: MapLink) throws {
        openCount += 1
    }
}

final class MapOpenerDummy: MapOpenerProtocol {
    func open(_ link: MapLink) throws {}
}
#endif
