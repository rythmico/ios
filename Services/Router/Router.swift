import SwiftUI

class Router: ObservableObject {
    @Published
    private(set) var route: Route?

    func open(_ route: Route) {
        self.route = route
    }

    func end() {
        DispatchQueue.main.async {
            self.route = nil
        }
    }
}

protocol RoutableView: View {
    func handleRoute(_ route: Route)
}

extension View {
    func routable<RV: RoutableView>(_ view: RV, router: Router = Current.router) -> some View {
        onReceive(router.$route) { $0.map(view.handleRoute) }
    }
}
