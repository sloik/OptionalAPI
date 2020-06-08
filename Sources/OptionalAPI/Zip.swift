
import Foundation

// https://hoogle.haskell.org/?hoogle=zip

// MARK: Zip on Optionals
@discardableResult
public func zip<A, B>(
  _ a: A?,
  _ b: B?
) -> (A, B)? {
    guard let a = a, let b = b else { return .none }

    return (a,b)
}

@discardableResult
public func zip<A, B, C>(
  _ a: A?,
  _ b: B?,
  _ c: C?
  ) -> (A, B, C)? {
  return zip(zip(a, b), c).map { ($0.0, $0.1, $1) }
}

@discardableResult
public func zip<A, B, C, D>(
  _ a: A?,
  _ b: B?,
  _ c: C?,
  _ d: D?
  ) -> (A, B, C, D)? {
  return zip(zip(a, b), c, d).map { ($0.0, $0.1, $1, $2) }
}

@discardableResult
public func zip<A, B, C, D, E>(
  _ a: A?,
  _ b: B?,
  _ c: C?,
  _ d: D?,
  _ e: E?
  ) -> (A, B, C, D, E)? {
  return zip(zip(a, b), c, d, e).map { ($0.0, $0.1, $1, $2, $3) }
}

@discardableResult
public func zip<A, B, C, D, E, F>(
  _ a: A?,
  _ b: B?,
  _ c: C?,
  _ d: D?,
  _ e: E?,
  _ f: F?
  ) -> (A, B, C, D, E, F)? {
  return zip(zip(a, b), c, d, e, f).map { ($0.0, $0.1, $1, $2, $3, $4) }
}

@discardableResult
public func zip<A, B, C, D, E, F, G>(
  _ a: A?,
  _ b: B?,
  _ c: C?,
  _ d: D?,
  _ e: E?,
  _ f: F?,
  _ g: G?
  ) -> (A, B, C, D, E, F, G)? {
  return zip(zip(a, b), c, d, e, f, g).map { ($0.0, $0.1, $1, $2, $3, $4, $5) }
}

@discardableResult
public func zip<A, B, C, D, E, F, G, H>(
  _ a: A?,
  _ b: B?,
  _ c: C?,
  _ d: D?,
  _ e: E?,
  _ f: F?,
  _ g: G?,
  _ h: H?
  ) -> (A, B, C, D, E, F, G, H)? {
  return zip(zip(a, b), c, d, e, f, g, h).map { ($0.0, $0.1, $1, $2, $3, $4, $5, $6) }
}

@discardableResult
public func zip<A, B, C, D, E, F, G, H, I>(
  _ a: A?,
  _ b: B?,
  _ c: C?,
  _ d: D?,
  _ e: E?,
  _ f: F?,
  _ g: G?,
  _ h: H?,
  _ i: I?
  ) -> (A, B, C, D, E, F, G, H, I)? {
  return zip(zip(a, b), c, d, e, f, g, h, i).map { ($0.0, $0.1, $1, $2, $3, $4, $5, $6, $7) }
}

@discardableResult
public func zip<A, B, C, D, E, F, G, H, I, J>(
  _ a: A?,
  _ b: B?,
  _ c: C?,
  _ d: D?,
  _ e: E?,
  _ f: F?,
  _ g: G?,
  _ h: H?,
  _ i: I?,
  _ j: J?
  ) -> (A, B, C, D, E, F, G, H, I, J)? {
  return zip(zip(a, b), c, d, e, f, g, h, i, j).map { ($0.0, $0.1, $1, $2, $3, $4, $5, $6, $7, $8) }
}

// MARK: -
