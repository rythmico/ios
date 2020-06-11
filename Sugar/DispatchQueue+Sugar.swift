import Foundation

extension Optional where Wrapped == DispatchQueue {
    /// Submits a work item to a dispatch queue, if it exists.
    /// Otherwise, execute immediately.
    public func asyncOrImmediate(execute work: @escaping @convention(block) () -> Void) {
        guard let self = self else {
            work()
            return
        }
        self.async(execute: work)
    }
}
