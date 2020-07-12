import Foundation
import Sugar

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

    var authenticatedValue: MainTabView? {
        if case .authenticated(let v) = self { return v } else { return nil }
    }
}

extension ActivityCoordinator.State {
    var isIdle: Bool {
        guard case .idle = self else {
            return false
        }
        return true
    }

    var isLoading: Bool {
        guard case .loading = self else {
            return false
        }
        return true
    }

    var isFinished: Bool {
        finishedValue != nil
    }

    var finishedValue: Output? {
        guard case .finished(let output) = self else {
            return nil
        }
        return output
    }
}

extension ActivityCoordinator.State where Output: AnyResult {
    var successValue: Output.Success? {
        try? finishedValue?.get()
    }

    var failureValue: Output.Failure? {
        do {
            _ = try finishedValue?.get()
        } catch {
            return error as? Output.Failure
        }
        return nil
    }

    var isSuccess: Bool {
        successValue != nil
    }
}
