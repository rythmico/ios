extension Result {
    public init?(value: Success?, error: Failure?) {
        switch (value, error) {
        case (let value?, _):
            self = .success(value)
        case (_, let error?):
            self = .failure(error)
        case (nil, nil):
            return nil
        }
    }
}

extension Result where Success == Void {
    public static var success: Result { .success(()) }
}

extension Result {
    public func eraseError() -> Result<Success, Error> {
        mapError { $0 as Error }
    }
}
