/// Returns the greatest common divisor of the given integers.
@inlinable
internal func gcd<T : BinaryInteger>(_ a: T, _ b: T) -> T {
    // Binary gcd algorithm:
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
    // Stopping condition.
    guard x != 0 else { return T(y) }
    // gcd(x, 0) = gcd(0, x) = x
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
    }
    while x != 0
    // y is left shifted by min(xtz, ytz) to account for
    // all the cases where x and y were both even.
    return T(y << min(xtz, ytz))
}
