public typealias Action = () -> Void
public typealias Handler<T> = (T) -> Void
public typealias ResultHandler<Success, Failure: Error> = Handler<Result<Success, Failure>>
