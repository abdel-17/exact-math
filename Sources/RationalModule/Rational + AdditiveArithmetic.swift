/// A type representing an error during arithmetic.
public enum ArithmeticError: Error {
    /// The result is valid, but overflows.
    case overflow
    
    /// The divisor is zero.
    case divisionByZero
    
    /// Evaluating a function at an input
    /// outside of its domain.
    case outOfDomain
}

extension Rational: AdditiveArithmetic {
    @inlinable
    public static func + (lhs: Rational, rhs: Rational) -> Rational {
        lhs.formingCommonDenominator(with: rhs, operation: +)
    }
    
    @inlinable
    public static func - (lhs: Rational, rhs: Rational) -> Rational {
        lhs.formingCommonDenominator(with: rhs, operation: -)
    }
}

extension Rational {
    /// Returns the result of adding `rhs` to `lhs`,
    /// or throws an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `+`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    public static func &+ (lhs: Rational, rhs: Rational) throws -> Rational {
        try lhs.formingCommonDenominatorOrThrows(with: rhs) {
            $0.addingReportingOverflow($1)
        }
    }
    
    /// Returns the result of subtracting `rhs` from `lhs`,
    /// or throws an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `-`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    public static func &- (lhs: Rational, rhs: Rational) throws -> Rational {
        // We don't simply do `lhs &+ -rhs` because `-rhs` could overflow.
        try lhs.formingCommonDenominatorOrThrows(with: rhs) {
            $0.subtractingReportingOverflow($1)
        }
    }
    
    /// Returns the result of forming a common denominator
    /// with `other` and combining the numerators using
    /// the given closure.
    @inlinable
    internal func formingCommonDenominator(with other: Rational,
                                           operation: (IntegerType, IntegerType) -> IntegerType) -> Rational {
        let (n1, d1) = self.numeratorAndDenominator
        let (n2, d2) = other.numeratorAndDenominator
        let g1 = gcd(d1, d2)
        // We form a common denominator using
        // the least common multiple function.
        //
        // lcm(d1, d2) = d1 * d2 / gcd(d1, d2)
        //
        // n1 * (d2 / g1)   n2 * (d1 / g1)
        // -------------- ± -------------
        // d1 * (d2 / g1)   d2 * (d1 / g1)
        let numerator = operation(n1 * (d2 / g1), n2 * (d1 / g1))
        let denominator = d1 * (d2 / g1)
        // If the denominators are coprime, we don't need
        // to reduce the fraction.
        guard g1 != 1 else {
            return Rational(numerator: numerator, denominator: denominator)
        }
        // gcd(numerator, denominator) = gcd(numerator, g1).
        // This is faster to compute as g1 is, in most cases,
        // less than denominator.
        let g2 = gcd(numerator, g1)
        return Rational(numerator: numerator / g2, denominator: denominator / g2)
    }
    
    /// Returns the result of forming a common denominator
    /// with `other` and combining the numerators using
    /// the given closure, or throws an error on overflow.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    internal func formingCommonDenominatorOrThrows(with other: Rational,
                                                   operation: (IntegerType, IntegerType) -> (partialValue: IntegerType,
                                                                                             overflow: Bool)) throws -> Rational {
        // See `formingCommonDenominator` for more details.
        let (n1, d1) = self.numeratorAndDenominator
        let (n2, d2) = other.numeratorAndDenominator
        let g1 = gcd(d1, d2)
        let (lhsNumerator, overflow1) = n1.multipliedReportingOverflow(by: d2 / g1)
        let (rhsNumerator, overflow2) = n2.multipliedReportingOverflow(by: d1 / g1)
        let (numerator, overflow3) = operation(lhsNumerator, rhsNumerator)
        let (denominator, overflow4) = d1.multipliedReportingOverflow(by: d2 / g1)
        guard !overflow1 && !overflow2 && !overflow3 && !overflow4 else {
            throw ArithmeticError.overflow
        }
        guard g1 != 1 else {
            return Rational(numerator: numerator, denominator: denominator)
        }
        let g2 = gcd(numerator, g1)
        return Rational(numerator: numerator / g2, denominator: denominator / g2)
    }
}
