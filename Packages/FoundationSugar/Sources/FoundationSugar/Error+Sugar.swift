extension String: LocalizedError {
    public var errorDescription: String? { self }
}

extension NSError {
    public convenience init(
        domain: String? = nil,
        code: Int,
        localizedDescription: String
    ) {
        self.init(
            domain: .empty,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: localizedDescription]
        )
    }
}
