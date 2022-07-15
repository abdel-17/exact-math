extension Rational: AdditiveArithmetic {
    public static func + (lhs: Rational, rhs: Rational) -> Rational {
        lhs.formingCommonDenominator(with: rhs, operation: +)
    }
    
    public static func - (lhs: Rational, rhs: Rational) -> Rational {
        lhs.formingCommonDenominator(with: rhs, operation: -)
    }
}

extension Rational {
    /// Returns the result of adding `rhs` to `lhs`,
    /// or `nil` on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `+`.
    public static func &+ (lhs: Rational, rhs: Rational) -> Rational? {
        lhs.formingCommonDenominatorOrNil(with: rhs) {
            $0.addingReportingOverflow($1)
        }
    }
    
    /// Returns the result of subtracting `rhs` from `lhs`,
    /// or `nil` on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `-`.
    public static func &- (lhs: Rational, rhs: Rational) -> Rational? {
        // We don't simply do lhs &+ -rhs because -rhs could overflow.
        lhs.formingCommonDenominatorOrNil(with: rhs) {
            $0.subtractingReportingOverflow($1)
        }
    }
    
    /// Returns the result of forming a common denominator
    /// with `other` and combining the numerators using
    /// the given closure.
    internal func formingCommonDenominator(with other: Rational,
                                           operation: (IntegerType, IntegerType) -> IntegerType) -> Rational {
        let (n1, d1) = numeratorAndDenominator
        let (n2, d2) = other.numeratorAndDenominator
        let g1 = gcd(d1, d2)
        // We form a common denominator using
        // the least common multiple function.
        //
        // lcm(d1, d2) = d1 * d2 / g1
        //
        // n1 * (d2 / g1)   n2 * (d1 / g1)
        // -------------- ± -------------
        // d1 * (d2 / g1)   d2 * (d1 / g1)
        let lhsMultiplier = d2 / g1
        let rhsMultiplier = d1 / g1
        let numerator = operation(n1 * lhsMultiplier, n2 * rhsMultiplier)
        let denominator = d1 * lhsMultiplier
        // gcd(numerator, denominator) = gcd(numerator, g1).
        // This is faster to compute as g1 is, in most cases,
        // less than the denominator.
        let g2 = gcd(numerator, g1)
        return Rational(numerator: numerator / g2, denominator: denominator / g2)
    }
    
    internal typealias OverflowReportingOperation = (IntegerType, IntegerType) -> (partialValue: IntegerType,
                                                                                   overflow: Bool)
    
    /// Returns the result of forming a common denominator
    /// with `other` and combining the numerators using
    /// the given closure, or `nil` on overflow.
    internal func formingCommonDenominatorOrNil(with other: Rational,
                                                operation: OverflowReportingOperation) -> Rational? {
        // See `formingCommonDenominator` for more details.
        let (n1, d1) = numeratorAndDenominator
        let (n2, d2) = other.numeratorAndDenominator
        let g1 = gcd(d1, d2)
        let lhsMultiplier = d2 / g1
        let rhsMultiplier = d1 / g1
        let (lhsNumerator, overflow1) = n1.multipliedReportingOverflow(by: lhsMultiplier)
        let (rhsNumerator, overflow2) = n2.multipliedReportingOverflow(by: rhsMultiplier)
        let (numerator, overflow3) = operation(lhsNumerator, rhsNumerator)
        let (denominator, overflow4) = d1.multipliedReportingOverflow(by: lhsMultiplier)
        guard !overflow1 && !overflow2 && !overflow3 && !overflow4 else { return nil }
        let g2 = gcd(numerator, g1)
        return Rational(numerator: numerator / g2, denominator: denominator / g2)
    }
}
