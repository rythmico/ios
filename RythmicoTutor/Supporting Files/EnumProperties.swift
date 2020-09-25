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

    var authenticatedValue: MainView? {
        if case .authenticated(let v) = self { return v } else { return nil }
    }
}

extension ActivityCoordinator.State {
    var isReady: Bool {
        guard case .ready = self else { return false }
        return true
    }

    var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }

    var isFinished: Bool {
        finishedValue != nil
    }

    var finishedValue: Output? {
        guard case .finished(let output) = self else { return nil }
        return output
    }

    var isIdle: Bool {
        guard case .idle = self else { return false }
        return true
    }
}

extension ActivityCoordinator.State where Output: AnyResult {
    var successValue: Output.Success? {
        finishedValue?.successValue
    }

    var failureValue: Output.Failure? {
        finishedValue?.failureValue
    }

    var isSuccess: Bool {
        successValue != nil
    }

    var isFailure: Bool {
        failureValue != nil
    }
}

extension PushNotificationAuthorizationCoordinator.Status {
    var isNotDetermined: Bool {
        guard case .notDetermined = self else { return false }
        return true
    }

    var isAuthorizing: Bool {
        guard case .authorizing = self else { return false }
        return true
    }

    var isFailed: Bool {
        failedValue != nil
    }

    var failedValue: Error? {
        guard case .failed(let error) = self else { return nil }
        return error
    }

    var isDenied: Bool {
        guard case .denied = self else { return false }
        return true
    }

    var isAuthorized: Bool {
        guard case .authorized = self else { return false }
        return true
    }

    var isDetermined: Bool {
        switch self {
        case .notDetermined, .authorizing, .failed:
            return false
        case .denied, .authorized:
            return true
        }
    }
}
