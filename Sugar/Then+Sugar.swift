import Foundation
import Then

extension Then where Self: Any {
    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        with { $0[keyPath: keyPath] = value }
    }
}

extension URLRequest: Then {}
