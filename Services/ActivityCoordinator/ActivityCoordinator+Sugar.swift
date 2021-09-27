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

    var output: Output? {
        guard case .finished(let output) = self else { return nil }
        return output
    }

    var isIdle: Bool {
        guard case .idle = self else { return false }
        return true
    }
}

// TODO: use parameterized extensions when available
// https://forums.swift.org/t/parameterized-extensions/25563

extension ActivityCoordinator.State {
    func isSucceeded<Success, Failure: Error>() -> Bool where Output == Result<Success, Failure> {
        output?.isSuccess == true
    }

    func isFailed<Success, Failure: Error>() -> Bool where Output == Result<Success, Failure> {
        output?.isFailure == true
    }
}

extension ActivityCoordinator {
    func isSucceeded<Success, Failure: Error>() -> Bool where Output == Result<Success, Failure> {
        self.output?.isSuccess == true
    }

    func isFailed<Success, Failure: Error>() -> Bool where Output == Result<Success, Failure> {
        self.output?.isFailure == true
    }
}
