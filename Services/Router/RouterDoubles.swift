import FoundationSugar

final class RouterSpy: RouterProtocol {
    var didOpen: Handler<Route>
    var didEnd: Action

    init(didOpen: @escaping Handler<Route>, didEnd: @escaping Action) {
        self.didOpen = didOpen
        self.didEnd = didEnd
    }

    func open(_ route: Route) {
        didOpen(route)
    }
}

final class RouterDummy: RouterProtocol {
    func open(_ route: Route) {}
}
