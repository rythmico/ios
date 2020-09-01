import Foundation
import Combine

extension URLSessionTask: Cancellable {}

final class CancellableSpy: Cancellable {
    private(set) var cancelCount = 0

    func cancel() {
        cancelCount += 1
    }
}

final class CancellableDummy: Cancellable {
    func cancel() {}
}
