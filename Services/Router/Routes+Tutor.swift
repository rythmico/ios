import Foundation

enum Route {
    case bookingRequests
    case bookingApplications
    case viewingRequest(BookingRequest)
    case viewingApplication(BookingApplication)
}

extension Router {
    func open(_ route: Route) {
        let state = Current.state

        switch route {
        case .bookingRequests:
            state.tab = .requests
            state.requestsTab = .open
            state.requestsContext = .none
        case .bookingApplications:
            state.tab = .requests
            state.requestsTab = .applied
            state.requestsContext = .none
        case .viewingRequest(let request):
            state.tab = .requests
            state.requestsTab = .open
            state.requestsContext = .viewingRequest(request)
        case .viewingApplication(let application):
            state.tab = .requests
            state.requestsTab = .applied
            state.requestsContext = .viewingApplication(application)
        }
    }
}
