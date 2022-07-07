/// Returns the greatest common divisor of the given integers.
@inlinable
internal func gcd<T : UnsignedInteger>(_ x: T, _ y: T) -> T {
    // Passing zero to the denominator position
    // indicates something went wrong, so we
    // don't account for this case. If you want
    // to use this algorithm for another use
    // case, simply replace the assert with
    // `guard y != 0 else { return x }`.
    assert(y != 0)
    // Implements the binary gcd algorithm.
    //
    // 1) x and y are both even:
    // -------------------------
    // 2 is a common divisior.
    // gcd(x, y) = 2 * gcd(x / 2, y / 2)
    //
    // Otherwise, x or y is odd.
    //
    // 2) x is even:
    // -------------
    // gcd(x, y) = gcd(x / 2, y) (2 is not a common divisor.)
    //
    // 3) y is even:
    // -------------
    // gcd(x, y) = gcd(x, y / 2) (By symmetry.)
    //
    // 4) x and y are both odd:
    // ------------------------
    // gcd(x, y) = if x < y: gcd(y, x)
    //             else    : gcd(x - y, y)
    //
    // Stopping condition:
    // -------------------
    // gcd(0, y) = y
    guard x != 0 else { return y }
    var x = x
    var y = y
    let xtz = x.trailingZeroBitCount
    let ytz = y.trailingZeroBitCount
    y >>= ytz
    repeat {
        x >>= x.trailingZeroBitCount
        // x and y are odd after the right shift.
        if x < y { swap(&x, &y) }
        x -= y
        // x is now even, but y remains odd.
    } while x != 0
    // y is left shifted by min(xtz, ytz) to account for
    // all the cases where x and y were both even.
    return y << min(xtz, ytz)
}

/// Returns the given fraction in its simplest form.
///
/// A fraction is reduced iff its numerator and
/// denominator are coprime.
@inlinable
internal func reduced<T : UnsignedInteger>(_ numerator: T,
                                           _ denominator: T) -> (numerator: T,
                                                                 denominator: T) {
    let g = gcd(numerator, denominator)
    // 61% of randomly chosen integers are coprime,
    // so we handle this case efficiently.
    guard g != 1 else { return (numerator, denominator) }
    return (numerator / g, denominator / g)
}
