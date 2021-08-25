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
public func => <Subject>(subject: Subject, do: (inout Subject) throws -> Void) rethrows -> Subject {
    var copy = subject
    try `do`(&copy)
    return copy
}

@_disfavoredOverload
@discardableResult
@inlinable
public func ?=> <Subject>(subject: Subject?, do: (inout Subject) throws -> Void) rethrows -> Subject? {
    guard let subject = subject else { return nil }
    var copy = subject
    try `do`(&copy)
    return copy
}

// MARK: - Do (Reference Types) -

@discardableResult
@inlinable
public func => <Subject: AnyObject>(subject: Subject, do: (Subject) throws -> Void) rethrows -> Subject {
    try `do`(subject)
    return subject
}

@discardableResult
@inlinable
public func ?=> <Subject: AnyObject>(subject: Subject?, do: (Subject) throws -> Void) rethrows -> Subject? {
    guard let subject = subject else { return nil }
    try `do`(subject)
    return subject
}

// MARK: - Mutate -

public typealias Mutation<Subject, Value> = (
    set: WritableKeyPath<Subject, Value>,
    to: Value
)

@discardableResult
@inlinable
public func => <Subject, Value>(subject: Subject, mutation: Mutation<Subject, Value>) -> Subject {
    return subject => { $0[keyPath: mutation.set] = mutation.to }
}

@discardableResult
@inlinable
public func ?=> <Subject, Value>(subject: Subject?, mutation: Mutation<Subject, Value>) -> Subject? {
    guard let subject = subject else { return nil }
    return subject => { $0[keyPath: mutation.set] = mutation.to }
}

// MARK: - Assign (Value Types) -

public typealias AssignmentToValue<Pointee, Subject> = (
    assignTo: UnsafeMutablePointer<Pointee>,
    WritableKeyPath<Pointee, Subject>
)

@discardableResult
@inlinable
public func => <Subject, Pointee>(subject: Subject, assignment: AssignmentToValue<Pointee, Subject>) -> Subject {
    return subject => { assignment.assignTo.pointee[keyPath: assignment.1] = $0 }
}

@discardableResult
@inlinable
public func => <Subject, Pointee>(subject: Subject, assignment: AssignmentToValue<Pointee, Subject?>) -> Subject {
    return subject => { assignment.assignTo.pointee[keyPath: assignment.1] = $0 }
}

@discardableResult
@inlinable
public func ?=> <Subject, Pointee>(subject: Subject?, assignment: AssignmentToValue<Pointee, Subject>) -> Subject? {
    guard let subject = subject else { return nil }
    return subject => { assignment.assignTo.pointee[keyPath: assignment.1] = $0 }
}

@discardableResult
@inlinable
public func ?=> <Subject, Pointee>(subject: Subject?, assignment: AssignmentToValue<Pointee, Subject?>) -> Subject? {
    guard let subject = subject else { return nil }
    return subject => { assignment.assignTo.pointee[keyPath: assignment.1] = $0 }
}

prefix operator /&
public prefix func /& <Value>(_ value: inout Value) -> UnsafeMutablePointer<Value> {
    withUnsafeMutablePointer(to: &value) { $0 }
}

// MARK: - Assign (Reference Types) -

public typealias AssignmentToReference<Pointee: AnyObject, Subject> = (
    assignTo: Pointee,
    ReferenceWritableKeyPath<Pointee, Subject>
)

@discardableResult
@inlinable
public func => <Subject, Pointee: AnyObject>(subject: Subject, assignment: AssignmentToReference<Pointee, Subject>) -> Subject {
    return subject => { assignment.assignTo[keyPath: assignment.1] = $0 }
}

@discardableResult
@inlinable
public func => <Subject, Pointee: AnyObject>(subject: Subject, assignment: AssignmentToReference<Pointee, Subject?>) -> Subject {
    return subject => { assignment.assignTo[keyPath: assignment.1] = $0 }
}

@discardableResult
@inlinable
public func ?=> <Subject, Pointee: AnyObject>(subject: Subject?, assignment: AssignmentToReference<Pointee, Subject>) -> Subject? {
    guard let subject = subject else { return nil }
    return subject => { assignment.assignTo[keyPath: assignment.1] = $0 }
}

@discardableResult
@inlinable
public func ?=> <Subject, Pointee: AnyObject>(subject: Subject?, assignment: AssignmentToReference<Pointee, Subject?>) -> Subject? {
    guard let subject = subject else { return nil }
    return subject => { assignment.assignTo[keyPath: assignment.1] = $0 }
}
