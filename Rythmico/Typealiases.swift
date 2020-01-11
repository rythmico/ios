import Swift

typealias Action = () -> Void
typealias Handler<T> = (T) -> Void

typealias ResultHandler<V, E: Error> = Handler<Result<V, E>>

typealias SimpleResult<V> = Result<V, Error>
typealias SimpleResultHandler<V> = Handler<SimpleResult<V>>
