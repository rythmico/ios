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

extension ActivityCoordinator.State {
    func successValue<Success, Failure: Error>() -> Success? where Output == Result<Success, Failure> {
        finishedValue?.value
    }

    func failureValue<Success, Failure: Error>() -> Failure? where Output == Result<Success, Failure> {
        finishedValue?.error
    }

    func isSuccess<Success, Failure: Error>() -> Bool where Output == Result<Success, Failure> {
        finishedValue?.isSuccess == true
    }

    func isFailure<Success, Failure: Error>() -> Bool where Output == Result<Success, Failure> {
        finishedValue?.isFailure == true
    }
}
