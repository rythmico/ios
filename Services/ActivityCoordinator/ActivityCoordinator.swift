import Combine

class ActivityCoordinator<Output>: ObservableObject {
    enum State {
        case ready
        case loading
        case suspended
        case finished(Output)
        case idle
    }

    @Published
    /*protected(set)*/ var state: State = .ready

    func resume() {
        if case .suspended = state {
            state = .loading
        }
    }

    func suspend() {
        if case .loading = state {
            state = .suspended
        }
    }

    func cancel() {
        switch state {
        case .suspended, .loading:
            state = .ready
        default:
            break
        }
    }

    func complete(_ output: Output) {
        state = .finished(output)
    }

    func reset() {
        cancel()
        state = .ready
    }

    deinit {
        cancel()
    }
}

class FailableActivityCoordinator<Success>: ActivityCoordinator<Result<Success, Error>> {
    func idle() {
        if case .finished(let result) = state, case .success = result {
            state = .idle
        }
    }

    func dismissFailure() {
        if case .finished(let result) = state, case .failure = result {
            state = .ready
        }
    }
}
