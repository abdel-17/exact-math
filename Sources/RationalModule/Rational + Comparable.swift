extension Rational: Comparable {
    @inlinable
    public static func < (lhs: Rational, rhs: Rational) -> Bool {
        // Handle the zero case separately to correctly
        // compare against -0.
        guard !lhs.isZero else {
            // 0 < rhs
            return rhs.sign == .plus
        }
        guard !rhs.isZero else {
            // lhs < 0
            return lhs.sign == .minus
        }
        // Neither lhs nor rhs is zero.
        // Check if both have the same sign.
        guard lhs.sign == rhs.sign else {
            // lhs must be negative.
            return lhs.hasNegativeSign
        }
        let (n1, d1) = lhs.fraction
        let (n2, d2) = rhs.fraction
        // case (-, -): lhs.magnitude > rhs.magnitude
        // case (+, +): lhs.magnitude < rhs.magnitude
        //
        // n1   n2
        // -- < --
        // d1   d2
        //
        // n1 * d2   d1 * n2
        // ------- < -------
        // d1 * d2   d1 * d2
        //
        // The denominators are equal, so we compare the numerators.
        guard let x = n1.multipliedOrNil(by: d2),
              let y = n2.multipliedOrNil(by: d1)
        else {
            // Only resort to the slow path on overflow.
            let x = n1.multipliedFullWidth(by: d2)
            let y = n2.multipliedFullWidth(by: d1)
            return lhs.hasNegativeSign ? x > y : x < y
        }
        return lhs.hasNegativeSign ? x > y : x < y
    }
}
