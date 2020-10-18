import SwiftUI
import Combine

protocol RouterProtocol {
    func open(_ route: Route)
}

final class Router: RouterProtocol {
    func open(_ route: Route) {
        let state = Current.state

        switch route {
        case .lessons:
            state.do {
                $0.tab = .lessons
                $0.isRequestingLessonPlan = false
                $0.selectedLessonPlan = nil
                $0.reviewingLessonPlan = nil
            }
        case .profile:
            state.do {
                $0.tab = .profile
                $0.isRequestingLessonPlan = false
            }
        case .requestLessonPlan:
            state.do {
                $0.tab = .lessons
                $0.isRequestingLessonPlan = true
            }
        }
    }
}
