extension Dictionary where Value: OptionalProtocol {
    public func compacted() -> [Key: Value.Wrapped] {
        compactMapValues(\.value)
    }
}
