#if DEBUG
extension String: LocalizedError {
    public var errorDescription: String? { self }
}
#endif

extension NSError {
    public convenience init(
        domain: String? = nil,
        code: Int,
        localizedDescription: String
    ) {
        self.init(
            domain: domain ?? .empty,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: localizedDescription]
        )
    }
}
