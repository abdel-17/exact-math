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
    /// - Throws: `OverflowError` on overflow.
    static func &/ (lhs: Rational, rhs: Rational) throws -> Rational {
        guard let reciprocal = rhs.reciprocal,
              let result = try? lhs &* reciprocal
        else {
            throw OverflowError(operands: (lhs, rhs),
                                operation: .division)
        }
        return result
    }
    
    /// Divides `lhs` value by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `/=`.
    ///
    /// - Throws: `OverflowError` on overflow.
    static func &/= (lhs: inout Rational, rhs: Rational) throws {
        try lhs = lhs &/ rhs
    }
}
