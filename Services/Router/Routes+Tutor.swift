import FoundationSugar

enum Route {
    case bookingRequests
    case bookingApplications
    case viewingRequest(BookingRequest)
    case viewingApplication(BookingApplication)
}

extension Router {
    func open(_ route: Route) {
        let navigation = Current.navigation

        switch route {
        case .bookingRequests:
            navigation.selectedTab = .requests
            navigation.requestsFilter = .open
            navigation.requestsNavigation = .none
        case .bookingApplications:
            navigation.selectedTab = .requests
            navigation.requestsFilter = .applied
            navigation.requestsNavigation = .none
        case .viewingRequest(let request):
            navigation.selectedTab = .requests
            navigation.requestsFilter = .open
            navigation.requestsNavigation = .viewingRequest(request)
        case .viewingApplication(let application):
            navigation.selectedTab = .requests
            navigation.requestsFilter = .applied
            navigation.requestsNavigation = .viewingApplication(application)
        }
    }
}
