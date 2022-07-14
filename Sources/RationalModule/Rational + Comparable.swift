extension Rational: Comparable {
    public static func < (lhs: Rational, rhs: Rational) -> Bool {
        // Add fast paths for comparison against 0.
        // lhs < 0
        if rhs.isZero { return lhs.isNegative }
        // rhs is non-zero.
        // 0 < rhs <=> !(rhs <= 0) <=> !(rhs < 0)
        if lhs.isZero { return !rhs.isNegative }
        let (n1, d1) = lhs.numeratorAndDenominator
        let (n2, d2) = rhs.numeratorAndDenominator
        // n1   n2
        // -- < --
        // d1   d2
        //
        // n1 * d2   d1 * n2
        // ------- < -------
        // d1 * d2   d1 * d2
        //
        // The denominators are equal, so we compare the numerators.
        // - Note: This only works under the assumption that the
        // common denominator is non-negative.
        do {
            return try multiplyThrowingOnOverflow(n1, d2) < multiplyThrowingOnOverflow(d1, n2)
        } catch {
            // Resort to the slow path only when needed.
            return n1.multipliedFullWidth(by: d2) < d1.multipliedFullWidth(by: n2)
        }
    }
}
