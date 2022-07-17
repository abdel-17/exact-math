import RealModule

extension Rational: AlgebraicField {
    public static func / (lhs: Rational, rhs: Rational) -> Rational {
        // n1   n2   n1   d2
        // -- / -- = -- * --
        // d1   d2   d1   n2
        //
        // See `*` for more details.
        Rational(lhs.numerator, rhs.numerator).multiplied(by: Rational(rhs.denominator, lhs.denominator))
    }
    
    public static func /= (lhs: inout Rational, rhs: Rational) {
        lhs = lhs / rhs
    }
}

infix operator &/: MultiplicationPrecedence

public extension Rational {
    /// Returns the result of dividing `lhs` by `rhs`,
    /// or throws an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `/`.
    ///
    /// - Throws: `ArithmeticError.divisionByZero` if `rhs` is zero;
    /// otherwise, `ArithmeticError.overflow` on overflow.
    static func &/ (lhs: Rational, rhs: Rational) throws -> Rational {
        // See `/` for more details.
        guard !rhs.isZero else { throw ArithmeticError.divisionByZero }
        let (n1, d1) = lhs.numeratorAndDenominator
        let (n2, d2) = rhs.numeratorAndDenominator
        // n1/n2 overflows if n2 is `.min` and n1 is odd
        // because `-.min` overflows.
        guard n2 != .min || n1.isMultiple(of: 2) else {
            throw ArithmeticError.overflow
        }
        return try Rational(n1, n2).multipliedOrThrows(by: Rational(d2, d1))
    }
}
