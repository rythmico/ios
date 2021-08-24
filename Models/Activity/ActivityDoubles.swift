import FoundationEncore

final class ActivitySpy: Activity {
    private(set) var resumeCount = 0
    private(set) var suspendCount = 0
    private(set) var cancelCount = 0

    func resume() {
        resumeCount += 1
    }

    func suspend() {
        suspendCount += 1
    }

    func cancel() {
        cancelCount += 1
    }
}

final class ActivityDummy: Activity {
    func resume() {}
    func suspend() {}
    func cancel() {}
}
