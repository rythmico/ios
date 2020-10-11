import Foundation
import Sugar

final class RouterSpy: Router {
    var didOpen: Handler<Route>
    var didEnd: Action

    init(didOpen: @escaping Handler<Route>, didEnd: @escaping Action) {
        self.didOpen = didOpen
        self.didEnd = didEnd
    }

    override func open(_ route: Route) {
        didOpen(route)
    }

    override func end() {
        didEnd()
    }
}

final class RouterDummy: Router {
    override func open(_ route: Route) {}
    override func end() {}
}
