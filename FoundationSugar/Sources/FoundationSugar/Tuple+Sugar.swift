import Foundation

public func unwrap<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
    guard let a = a, let b = b else { return nil }
    return (a, b)
}

public func unwrap<A, B, C>(_ a: A?, _ b: B?, _ c: C?) -> (A, B, C)? {
    guard let a = a, let b = b, let c = c else { return nil }
    return (a, b, c)
}
