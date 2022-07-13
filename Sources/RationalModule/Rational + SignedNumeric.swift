extension Rational: Numeric {
    public static func * (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs &* rhs
    }
    
    public static func *= (lhs: inout Rational, rhs: Rational) {
        try! lhs &*= rhs
    }
    
    public mutating func negate() {
        self = Rational(numerator: -numerator,
                        denominator: denominator)
    }
}

public extension Rational {
    /// Returns the result of multiplying `lhs` by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `*`.
    ///
    /// - Throws: `OverflowError` on overflow.
    static func &* (lhs: Rational, rhs: Rational) throws -> Rational {
        var (n1, d1) = lhs.numeratorAndDenominator
        var (n2, d2) = rhs.numeratorAndDenominator
        reduceFraction(&n1, &d2)
        reduceFraction(&n2, &d1)
        guard let numerator = multiplyNilOnOverflow(n1, n2),
              let denominator = multiplyNilOnOverflow(d1, d2)
        else {
            throw OverflowError(operands: (lhs, rhs),
                                operation: .multiplication)
        }
        return Rational(numerator: numerator,
                        denominator: denominator)
    }
    
    /// Multiplies `lhs` by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `*=`.
    ///
    /// - Throws: `OverflowError` on overflow.
    static func &*= (lhs: inout Rational, rhs: Rational) throws {
        try lhs = lhs &* rhs
    }
}
