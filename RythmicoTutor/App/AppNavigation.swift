import FoundationSugar
import SwiftUI

final class AppNavigation: ObservableObject {
    @Published var selectedTab: MainView.Tab = .schedule
    @Published var scheduleFilter: BookingsTabView.Tab = .upcoming
    @Published var requestsFilter: BookingRequestsTabView.Tab = .open
    // TODO: use optional when Binding allows chaining optional sub-bindings.
    // e.g. $navigation.requestsContext(?).reviewingValues(?).0
    @Published var requestsNavigation: RequestsNavigation = .none

    func reset() {
        selectedTab = .schedule
        scheduleFilter = .upcoming
        requestsFilter = .open
        requestsNavigation = .none
    }
}

extension AppNavigation {
    enum RequestsNavigation: Equatable {
        case none
        case viewingRequest(BookingRequest)
        case applyingToRequest(BookingRequest)
        case viewingApplication(BookingApplication)
    }
}

extension AppNavigation.RequestsNavigation {
    var selectedRequest: BookingRequest? {
        get {
            switch self {
            case .none, .viewingApplication:
                return nil
            case .viewingRequest(let request), .applyingToRequest(let request):
                return request
            }
        }
        set {
            if let newValue = newValue {
                self = .viewingRequest(newValue)
            } else if selectedRequest != nil {
                self = .none
            }
        }
    }

    var isApplyingToRequest: Bool {
        get {
            switch self {
            case .none, .viewingRequest, .viewingApplication:
                return false
            case .applyingToRequest:
                return true
            }
        }
        set(isApplying) {
            if let selectedRequest = selectedRequest {
                if isApplying {
                    self = .applyingToRequest(selectedRequest)
                } else {
                    self = .viewingRequest(selectedRequest)
                }
            }
        }
    }

    var selectedApplication: BookingApplication? {
        get {
            switch self {
            case .none, .viewingRequest, .applyingToRequest:
                return nil
            case .viewingApplication(let application):
                return application
            }
        }
        set {
            if let newValue = newValue {
                self = .viewingApplication(newValue)
            } else if selectedApplication != nil {
                self = .none
            }
        }
    }
}
