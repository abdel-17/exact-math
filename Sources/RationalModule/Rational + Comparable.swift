extension FixedWidthInteger {
    /// Returns this value multiplied by `other`,
    /// or `nil` on overflow.
    @usableFromInline
    internal func multipliedOrNil(by other: Self) -> Self? {
        let (result, overflow) = self.multipliedReportingOverflow(by: other)
        return overflow ? nil : result
    }
}

extension Rational: Comparable {
    @inlinable
    public static func < (lhs: Rational, rhs: Rational) -> Bool {
        // Handle zero separately to correctly compare against -0.
        guard !rhs.isZero else {
            // lhs < 0
            return lhs.sign == .minus
        }
        guard !lhs.isZero else {
            // 0 < rhs
            return rhs.sign == .plus
        }
        // Neither lhs nor rhs is zero.
        // Check if both have the same sign.
        guard lhs.sign == rhs.sign else {
            // lhs must be negative.
            return lhs.hasNegativeSign
        }
        // (-, -): |rhs| < |lhs|
        // (+, +): |lhs| < |rhs|
        return lhs.hasNegativeSign ?
        rhs.isLessInMagnitude(than: lhs) :
        lhs.isLessInMagnitude(than: rhs)
    }
    
    /// Returns true iff this value compares less
    /// than `other` in magnitude.
    @inlinable
    internal func isLessInMagnitude(than other: Rational) -> Bool {
        let (n1, d1) = self.fraction
        let (n2, d2) = other.fraction
        // n1   n2
        // -- < --
        // d1   d2
        //
        // n1 * d2   d1 * n2
        // ------- < -------
        // d1 * d2   d1 * d2
        //
        // The denominators are equal, so we compare the numerators.
        guard let lhsNumerator = n1.multipliedOrNil(by: d2),
              let rhsNumerator = n2.multipliedOrNil(by: d1)
        else {
            // Resort to the slow path only when needed.
            return n1.multipliedFullWidth(by: d2) < d1.multipliedFullWidth(by: n2)
        }
        return lhsNumerator < rhsNumerator
    }
}
