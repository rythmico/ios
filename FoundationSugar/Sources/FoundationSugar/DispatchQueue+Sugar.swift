import Foundation

extension DispatchQueue {
    // Optimized for immediate main thread dispatching.
    public func immediateOrAsync(execute work: @escaping @convention(block) () -> Void) {
        if self == .main, Thread.isMainThread {
            work()
        } else {
            async(execute: work)
        }
    }
}
