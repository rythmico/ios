import SwiftUI
import Combine

class Router: ObservableObject {
    let objectWillChange = PassthroughSubject<Route?, Never>()

    private(set) var route: Route? {
        willSet {
            objectWillChange.send(newValue)
        }
    }

    func open(_ route: Route) {
        self.route = route
    }

    func end() {
        self.route = nil
    }
}

protocol RoutableView: View {
    func handleRoute(_ route: Route)
}

extension View {
    func routable<RV: RoutableView>(_ view: RV, router: Router = Current.router) -> some View {
        onReceive(router.objectWillChange) { $0.map(view.handleRoute) }
    }
}
