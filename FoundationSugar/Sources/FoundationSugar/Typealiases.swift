public typealias Action = () -> Void
public typealias Handler<T> = (T) -> Void

public typealias ResultHandler<V, E: Error> = Handler<Result<V, E>>

public typealias SimpleResult<V> = Result<V, Error>
public typealias SimpleResultHandler<V> = Handler<SimpleResult<V>>
