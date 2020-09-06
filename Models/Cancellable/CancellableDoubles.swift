#if DEBUG
import Foundation
import Combine

final class CancellableSpy: Cancellable {
    private(set) var cancelCount = 0

    func cancel() {
        cancelCount += 1
    }
}

final class CancellableDummy: Cancellable {
    func cancel() {}
}
#endif
