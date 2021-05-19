import Foundation

extension Sequence {
    @inlinable
    public func count(
        where predicate: (Element) throws -> Bool
    ) rethrows -> Int {
        var count = 0
        for e in self {
            if try predicate(e) {
                count += 1
            }
        }
        return count
    }

    public func compact<T>() -> [T] where Element == Optional<T> {
        compactMap { $0 }
    }
}

extension Sequence where Element: Sequence {
    public func flatten() -> [Element.Element] {
        flatMap { $0 }
    }
}

extension Sequence {
    public func sorted<T>(
        _ value: KeyPath<Element, T>,
        by areInIncreasingOrder: (T, T) throws -> Bool
    ) rethrows -> [Element] {
        try sorted(by: { try areInIncreasingOrder($0[keyPath: value], $1[keyPath: value]) })
    }

    public func sorted<T>(_ value: KeyPath<Element, T>) -> [Element] where T: Comparable {
        sorted(value, by: <)
    }
}

extension Sequence {
    public func min<T>(by value: KeyPath<Element, T>) -> Element? where T: Comparable {
        self.min(by: { $0[keyPath: value] < $1[keyPath: value] })
    }
}
