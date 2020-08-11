import Foundation

extension Collection {
    public var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}

extension RangeReplaceableCollection {
    public func appending(_ element: Element) -> Self {
        var _self = self
        _self.append(element)
        return _self
    }

    public static func + (lhs: Self, rhs: Element) -> Self {
        lhs.appending(rhs)
    }
}

extension RangeReplaceableCollection where Element: Equatable {
    public mutating func removeAll(_ element: Element) {
        self.removeAll(where: { $0 == element })
    }

    public func removingAll(_ element: Element) -> Self {
        var _self = self
        _self.removeAll(element)
        return _self
    }

    public func firstIndex<T: Equatable>(of element: Element, by value: (Element) -> T) -> Index? {
        firstIndex(where: { value($0) == value(element) })
    }
}
