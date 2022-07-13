/// Returns the greatest common divisor of the given integers.
internal func gcd<T : BinaryInteger>(_ a: T, _ b: T) -> T {
    // Passing zero to the denominator position
    // indicates something went wrong, so we
    // don't account for this case.
    assert(b != 0)
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
    var x = a.magnitude
    var y = b.magnitude
    guard y != 0 else { return T(x) }
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
    return T(y << min(xtz, ytz))
}

/// Reduces the given fraction to its simplest form.
///
/// A fraction is reduced iff its numerator and
/// denominator are coprime.
internal func reduceFraction<T : BinaryInteger>(_ numerator: inout T,
                                                _ denominator: inout T) {
    // 61% of randomly chosen integers are coprime,
    // so we handle this case efficiently.
    divide(&numerator, &denominator, by: gcd(numerator, denominator))
}

/// Reduces the given fraction to its simplest form.
///
/// A fraction is reduced iff its numerator and
/// denominator are coprime.
internal func divide<T : BinaryInteger>(_ numerator: inout T,
                                        _ denominator: inout T,
                                        by divisor: T) {
    guard divisor != 1 else { return }
    numerator /= divisor
    denominator /= divisor
}
