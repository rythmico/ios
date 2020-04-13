import Foundation

extension Collection {
    public var nilIfEmpty: Self? {
        isEmpty ? nil : self
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
}
