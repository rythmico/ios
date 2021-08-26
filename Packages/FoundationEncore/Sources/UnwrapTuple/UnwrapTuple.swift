public func unwrap<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
    guard let a = a, let b = b else { return nil }
    return (a, b)
}

public func unwrap<A, B, C>(_ a: A?, _ b: B?, _ c: C?) -> (A, B, C)? {
    guard let a = a, let b = b, let c = c else { return nil }
    return (a, b, c)
}

public func unwrap<A, B, C, D>(_ a: A?, _ b: B?, _ c: C?, _ d: D?) -> (A, B, C, D)? {
    guard let a = a, let b = b, let c = c, let d = d else { return nil }
    return (a, b, c, d)
}

public func unwrap<A, B, C, D, E>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?) -> (A, B, C, D, E)? {
    guard let a = a, let b = b, let c = c, let d = d, let e = e else { return nil }
    return (a, b, c, d, e)
}

public func unwrap<A, B, C, D, E, F>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?) -> (A, B, C, D, E, F)? {
    guard let a = a, let b = b, let c = c, let d = d, let e = e, let f = f else { return nil }
    return (a, b, c, d, e, f)
}

public func unwrap<A, B, C, D, E, F, G>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?) -> (A, B, C, D, E, F, G)? {
    guard let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g else { return nil }
    return (a, b, c, d, e, f, g)
}

public func unwrap<A, B, C, D, E, F, G, H>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ h: H?) -> (A, B, C, D, E, F, G, H)? {
    guard let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h else { return nil }
    return (a, b, c, d, e, f, g, h)
}

public func unwrap<A, B, C, D, E, F, G, H, I>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ h: H?, _ i: I?) -> (A, B, C, D, E, F, G, H, I)? {
    guard let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h, let i = i else { return nil }
    return (a, b, c, d, e, f, g, h, i)
}

public func unwrap<A, B, C, D, E, F, G, H, I, J>(_ a: A?, _ b: B?, _ c: C?, _ d: D?, _ e: E?, _ f: F?, _ g: G?, _ h: H?, _ i: I?, _ j: J?) -> (A, B, C, D, E, F, G, H, I, J)? {
    guard let a = a, let b = b, let c = c, let d = d, let e = e, let f = f, let g = g, let h = h, let i = i, let j = j else { return nil }
    return (a, b, c, d, e, f, g, h, i, j)
}
