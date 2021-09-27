import FoundationEncore

extension ActivityCoordinator.State {
    var isReady: Bool {
        guard case .ready = self else { return false }
        return true
    }

    var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }

    var isSuspended: Bool {
        guard case .suspended = self else { return false }
        return true
    }

    var isFinished: Bool {
        guard case .finished = self else { return false }
        return true
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

extension ActivityCoordinator.State where Output: ResultProtocol {
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
