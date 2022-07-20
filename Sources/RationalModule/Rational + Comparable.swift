extension Rational: Comparable {
    public static func < (lhs: Rational, rhs: Rational) -> Bool {
        let (n1, d1) = lhs.asRatio
        let (n2, d2) = rhs.asRatio
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
        let (lhsNumerator, overflow1) = n1.multipliedReportingOverflow(by: d2)
        let (rhsNumerator, overflow2) = d1.multipliedReportingOverflow(by: n2)
        guard !overflow1 && !overflow2 else {
            // Resort to the slow path only on overflow.
            return n1.multipliedFullWidth(by: d2) < d1.multipliedFullWidth(by: n2)
        }
        return lhsNumerator < rhsNumerator
    }
}
