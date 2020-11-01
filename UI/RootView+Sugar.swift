import Foundation

extension RootView.UserState {
    var isUnauthenticated: Bool {
        if case .unauthenticated = self { return true } else { return false }
    }

    var unauthenticatedValue: OnboardingView? {
        if case .unauthenticated(let v) = self { return v } else { return nil }
    }

    var isAuthenticated: Bool {
        if case .authenticated = self { return true } else { return false }
    }

    var authenticatedValue: MainView? {
        if case .authenticated(let v) = self { return v } else { return nil }
    }
}

