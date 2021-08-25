precedencegroup DoPrecedence {
    assignment: true
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator => : DoPrecedence
infix operator ?=> : DoPrecedence

// MARK: - Do (Value Types) -

@_disfavoredOverload
@discardableResult
@inlinable
public func => <Subject>(
    subject: Subject,
    do: (inout Subject) throws -> Void
) rethrows -> Subject {
    var copy = subject
    try `do`(&copy)
    return copy
}

@_disfavoredOverload
@discardableResult
@inlinable
public func ?=> <Subject>(
    subject: Subject?,
    do: (inout Subject) throws -> Void
) rethrows -> Subject? {
    guard let subject = subject else { return nil }
    var copy = subject
    try `do`(&copy)
    return copy
}

// MARK: - Do (Reference Types) -

@discardableResult
@inlinable
public func => <Subject: AnyObject>(
    subject: Subject,
    do: (Subject) throws -> Void
) rethrows -> Subject {
    try `do`(subject)
    return subject
}

@discardableResult
@inlinable
public func ?=> <Subject: AnyObject>(
    subject: Subject?,
    do: (Subject) throws -> Void
) rethrows -> Subject? {
    guard let subject = subject else { return nil }
    try `do`(subject)
    return subject
}

// MARK: - Mutate -

@discardableResult
@inlinable
public func => <Subject, Value>(
    subject: Subject,
    mutation: (set: WritableKeyPath<Subject, Value>, to: Value)
) -> Subject {
    return subject => { $0[keyPath: mutation.set] = mutation.to }
}

@discardableResult
@inlinable
public func ?=> <Subject, Value>(
    subject: Subject?,
    mutation: (set: WritableKeyPath<Subject, Value>, to: Value)
) -> Subject? {
    guard let subject = subject else { return nil }
    return subject => { $0[keyPath: mutation.set] = mutation.to }
}

// MARK: - Assign (Value Types) -

@discardableResult
@inlinable
public func => <Subject, Pointee>(
    subject: Subject,
    assignment: (assignTo: WritableKeyPath<Pointee, Subject>, on: UnsafeMutablePointer<Pointee>)
) -> Subject {
    return subject => { assignment.on.pointee[keyPath: assignment.assignTo] = $0 }
}

@discardableResult
@inlinable
public func => <Subject, Pointee>(
    subject: Subject,
    assignment: (assignTo: WritableKeyPath<Pointee, Subject?>, on: UnsafeMutablePointer<Pointee>)
) -> Subject {
    return subject => { assignment.on.pointee[keyPath: assignment.assignTo] = $0 }
}

@discardableResult
@inlinable
public func ?=> <Subject, Pointee>(
    subject: Subject?,
    assignment: (assignTo: WritableKeyPath<Pointee, Subject>, on: UnsafeMutablePointer<Pointee>)
) -> Subject? {
    guard let subject = subject else { return nil }
    return subject => { assignment.on.pointee[keyPath: assignment.assignTo] = $0 }
}

@discardableResult
@inlinable
public func ?=> <Subject, Pointee>(
    subject: Subject?,
    assignment: (assignTo: WritableKeyPath<Pointee, Subject?>, on: UnsafeMutablePointer<Pointee>)
) -> Subject? {
    guard let subject = subject else { return nil }
    return subject => { assignment.on.pointee[keyPath: assignment.assignTo] = $0 }
}

prefix operator /&
public prefix func /& <Value>(_ value: inout Value) -> UnsafeMutablePointer<Value> {
    withUnsafeMutablePointer(to: &value) { $0 }
}
