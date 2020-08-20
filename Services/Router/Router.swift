import SwiftUI

final class Router: ObservableObject {
    @Published
    private(set) var route: Route?

    func open(_ route: Route) {
        self.route = route
    }

    func end() {
        self.route = nil
    }
}

extension View {
    func onRoute(_ router: Router = Current.router, perform handler: @escaping (Route) -> Void) -> some View {
        onReceive(router.$route) { $0.map(handler) }
    }
}
