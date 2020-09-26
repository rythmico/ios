import Combine

class ActivityCoordinator<Input, Output>: ObservableObject {
    enum State {
        case ready
        case loading
        case suspended
        case finished(Output)
        case idle
    }

    @Published
    fileprivate(set) var state: State = .ready

    /*protected*/ var activity: Activity?
    private var idleOnFinished = false

    func start(with input: Input) {
        guard state.isReady else { return }
        idleOnFinished = false
        performTask(with: input)
    }

    func startToIdle(with input: Input) {
        guard state.isReady else { return }
        idleOnFinished = true
        performTask(with: input)
    }

    func run(with input: Input) {
        idleOnFinished = false
        performTask(with: input)
    }

    func runToIdle(with input: Input) {
        idleOnFinished = true
        performTask(with: input)
    }

    /*protected*/ func performTask(with input: Input) {
        state = .loading
    }

    func suspend() {
        if case .loading = state {
            state = .suspended
            activity?.suspend()
        }
    }

    func resume() {
        if case .suspended = state {
            state = .loading
            activity?.resume()
        }
    }

    func cancel() {
        switch state {
        case .loading, .suspended:
            state = .ready
            activity?.cancel()
            activity = nil
        default:
            break
        }
    }

    /*protected*/ func finish(_ output: Output) {
        state = .finished(output)
        activity = nil
        if idleOnFinished {
            idle()
        }
    }

    /*protected*/ func idle() {
        if case .finished = state {
            state = .idle
        }
    }

    func reset() {
        cancel()
        state = .ready
    }

    deinit {
        cancel()
    }
}

extension ActivityCoordinator where Input == Void {
    func start() { start(with: ()) }
    func startToIdle() { startToIdle(with: ()) }

    func run() { run(with: ()) }
    func runToIdle() { runToIdle(with: ()) }
}

class FailableActivityCoordinator<Input, Success>: ActivityCoordinator<Input, Result<Success, Error>> {
    override func idle() {
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
