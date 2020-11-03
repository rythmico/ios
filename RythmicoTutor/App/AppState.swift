import SwiftUI
import Then

final class AppState: ObservableObject {
    @Published var tab: MainView.Tab = .requests
    @Published var requestsTab: BookingRequestsTabView.Tab = .upcoming
    // TODO: use optional when Binding allows chaining optional sub-bindings.
    // e.g. $state.requestsContext(?).reviewingValues(?).0
    @Published var requestsContext: RequestsContext = .none
}

extension AppState {
    enum RequestsContext: Equatable {
        case none
        case viewingRequest(BookingRequest)
        case applyingToRequest(BookingRequest)
        case viewingApplication(BookingApplication)
    }
}

extension AppState.RequestsContext {
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
                    self = .none
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