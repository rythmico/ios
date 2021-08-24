import FoundationEncore

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

