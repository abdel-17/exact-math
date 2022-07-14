import RealModule

extension Rational: AlgebraicField {
    public static func / (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs &/ rhs
    }
    
    public static func /= (lhs: inout Rational, rhs: Rational) {
        try! lhs &/= rhs
    }
}

infix operator &/: MultiplicationPrecedence
infix operator &/=: AssignmentPrecedence

public extension Rational {
    /// Returns the result of dividing `lhs` by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `/`.
    ///
    /// - Throws: `ArithmeticError`
    /// on division by zero or overflow.
    static func &/ (lhs: Rational, rhs: Rational) throws -> Rational {
        guard !rhs.isZero else { throw ArithmeticError.divisionByZero }
        // n1   n2   n1   d2
        // -- / -- = -- * --
        // d1   d2   d1   n2
        //
        // See &* for more details.
        let (n1, d1) = lhs.numeratorAndDenominator
        let (n2, d2) = lhs.numeratorAndDenominator
        // If n2 is IntegerType.min, n1 must be even,
        // or else the value n1/n2 overflows because
        // the denominator is negative and shares no
        // common factors with the numerator.
        guard n2 != .min || n1.isMultiple(of: 2) else { throw ArithmeticError.overflow }
        return try Rational(n1, n2).multipliedThrowingOnOverflow(by: Rational(d2, d1))
    }
    
    /// Divides `lhs` value by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `/=`.
    ///
    /// - Throws: `ArithmeticError`
    /// on division by zero or overflow.
    static func &/= (lhs: inout Rational, rhs: Rational) throws {
        try lhs = lhs &/ rhs
    }
}
