import Foundation

protocol Resumeable {
    func resume()
}

protocol Suspendable {
    func suspend()
}

import protocol Combine.Cancellable

typealias Activity = Resumeable & Suspendable & Cancellable

extension URLSessionTask: Activity {}
