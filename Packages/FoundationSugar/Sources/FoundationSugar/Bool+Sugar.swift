extension Bool {
    public var not: Bool { !self }
    public var isTrue: Bool { self }
    public var isFalse: Bool { !self }
}

extension Bool: CaseIterable {
    public static var allCases: [Bool] { [false, true] }
}
