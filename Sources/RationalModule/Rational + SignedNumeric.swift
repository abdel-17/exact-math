extension Rational: Numeric {
    public static func * (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs &* rhs
    }
    
    public static func *= (lhs: inout Rational, rhs: Rational) {
        try! lhs &*= rhs
    }
    
    public mutating func negate() {
        self = Rational(numerator: -numerator, denominator: denominator)
    }
}

public extension Rational {
    /// Returns this value multiplied by `other`,
    /// throwing an error on overflow.
    ///
    /// - Throws: `ArithmeticError` on overflow.
    internal func multipliedThrowingOnOverflow(by other: Rational) throws -> Rational {
        try Rational(numerator: multiplyThrowingOnOverflow(numerator, other.numerator),
                     denominator: multiplyThrowingOnOverflow(denominator, other.denominator))
    }
    
    /// Returns the result of multiplying `lhs` by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `*`.
    ///
    /// - Throws: `ArithmeticError` on overflow.
    static func &* (lhs: Rational, rhs: Rational) throws -> Rational {
        // let g1 = gcd(n1, d2)
        // let g2 = gcd(n2, d1)
        //
        // n1 * n2   (n1 / g1) * (n2 / g2)
        // ------- = ---------------------
        // d1 * d2   (d2 / g1) * (d1 / g2)
        //
        // We reduce each pair instead of reducing
        // the products to avoid overflow.
        let (n1, d1) = lhs.numeratorAndDenominator
        let (n2, d2) = lhs.numeratorAndDenominator
        return try Rational(n1, d2).multipliedThrowingOnOverflow(by: Rational(n2, d1))
    }
    
    /// Multiplies `lhs` by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `*=`.
    ///
    /// - Throws: `ArithmeticError` on overflow.
    static func &*= (lhs: inout Rational, rhs: Rational) throws {
        try lhs = lhs &* rhs
    }
}
