import Foundation

extension RootView.UserState {
    var unauthenticatedValue: OnboardingView? {
        if case .unauthenticated(let v) = self { return v } else { return nil }
    }

    var authenticatedValue: MainTabView? {
        if case .authenticated(let v) = self { return v } else { return nil }
    }

    var isAuthenticated: Bool {
        if case .authenticated = self { return true } else { return false }
    }
}
