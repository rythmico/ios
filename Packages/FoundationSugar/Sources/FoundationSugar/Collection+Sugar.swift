extension Collection {
    public var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}

extension RangeReplaceableCollection where Index == Int {
    public subscript(safe index: Index) -> Element? {
        dropFirst(index).first
    }
}

extension RangeReplaceableCollection {
    public static func * <RHS: RangeReplaceableCollection>(lhs: Self, rhs: RHS) -> [(Self.Element, RHS.Element)] {
        var result: [(Self.Element, RHS.Element)] = []
        for l in lhs {
            for r in rhs {
                result.append((l, r))
            }
        }
        return result
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
        removeAll(where: { $0 == element })
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
