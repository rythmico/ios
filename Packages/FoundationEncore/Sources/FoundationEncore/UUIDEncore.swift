extension UUID {
    /// 00000000-0000-0000-0000-000000000000
    public static var zero: UUID { UUID(uuidInt: 0) }

    /// A deterministic, auto-incrementing UUID factory function.
    public static var incrementing: () -> UUID {
        var uuidInt = 0
        return {
            defer { uuidInt += 1 }
            return UUID(uuidInt: uuidInt)
        }
    }

    private init(uuidInt int: Int) {
        self = UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", int))") !! preconditionFailure(
            "Failed to create UUID with integer \(int)"
        )
    }
}
