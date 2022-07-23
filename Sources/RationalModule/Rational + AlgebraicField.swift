import RealModule

extension Rational: AlgebraicField {
    @inlinable
    public static func / (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs &/ rhs
    }
    
    @inlinable
    public static func /= (lhs: inout Rational, rhs: Rational) {
        lhs = lhs / rhs
    }
}

infix operator &/: MultiplicationPrecedence

public extension Rational {
    /// Returns the result of dividing `lhs` by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `/`.
    ///
    /// - Throws: `ArithmeticError.divisionByZero` if `rhs` is zero.
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    static func &/ (lhs: Rational, rhs: Rational) throws -> Rational {
        // n1   n2   n1   d2
        // -- / -- = -- * --
        // d1   d2   d1   n2
        guard !rhs.isZero else { throw ArithmeticError.divisionByZero }
        guard let reciprocal = rhs.reciprocal else {
            let (n1, d1) = lhs.asRatio
            let (n2, d2) = rhs.asRatio
            // n2 is `.min`, which is a power of two. If n1 is odd,
            // they share no common factors and n1 / n2 overflows.
            guard n1.isMultiple(of: 2) else { throw ArithmeticError.overflow }
            // See `&*` for more details.
            return try Rational(n1, n2).multiplied(by: Rational(d2, d1))
        }
        return try lhs &* reciprocal
    }
}
