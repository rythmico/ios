import ComposableNavigator

extension RangeReplaceableCollection where Element == IdentifiedScreen {
    func `is`<C>(_ other: C) -> Bool where C: RangeReplaceableCollection, C.Element == AnyScreen {
        guard self.count == other.count else { return false }
        for (lhs, rhs) in zip(self, other) where lhs.content != rhs {
            return false
        }
        return true
    }

    func `is`<R1: Screen>(
        _ r1: R1
    ) -> Bool {
        self.is([
            r1.eraseToAnyScreen()
        ])
    }

    func `is`<R1: Screen, R2: Screen>(
        _ r1: R1,
        _ r2: R2
    ) -> Bool {
        self.is([
            r1.eraseToAnyScreen(),
            r2.eraseToAnyScreen()
        ])
    }

    func `is`<R1: Screen, R2: Screen, R3: Screen>(
        _ r1: R1,
        _ r2: R2,
        _ r3: R3
    ) -> Bool {
        self.is([
            r1.eraseToAnyScreen(),
            r2.eraseToAnyScreen(),
            r3.eraseToAnyScreen()
        ])
    }

    func `is`<R1: Screen, R2: Screen, R3: Screen, R4: Screen>(
        _ r1: R1,
        _ r2: R2,
        _ r3: R3,
        _ r4: R4
    ) -> Bool {
        self.is([
            r1.eraseToAnyScreen(),
            r2.eraseToAnyScreen(),
            r3.eraseToAnyScreen(),
            r4.eraseToAnyScreen()
        ])
    }
}
