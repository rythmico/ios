extension Collection {
    public var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}

extension Collection {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0 else { return nil }
        return dropFirst(index).first
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

public func * <Base1: Sequence, Base2: Collection>(
    lhs: Base1,
    rhs: Base2
) -> Product2<Base1, Base2> {
    product(lhs, rhs)
}
