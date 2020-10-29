import SwiftUI
import Combine

protocol RouterProtocol {
    func open(_ route: Route)
}

final class Router: RouterProtocol {}
