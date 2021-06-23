extension Bool {
    public var not: Bool { !self }
}

extension Bool: CaseIterable {
    public static var allCases: [Bool] { [true, false] }
}
