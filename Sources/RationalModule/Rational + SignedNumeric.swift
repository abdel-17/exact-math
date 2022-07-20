extension Rational: Numeric {
    @inlinable
    public static func * (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs &* rhs
    }
    
    @inlinable
    public static func *= (lhs: inout Rational, rhs: Rational) {
        lhs = lhs * rhs
    }
    
    /// Replaces this value with the additive inverse.
    ///
    /// Equivalent to negating the numerator.
    ///
    /// If the numerator is `IntegerType.min`,
    /// the additive inverse cannot be represented.
    @inlinable
    public mutating func negate() {
        self = Rational(numerator: -numerator, denominator: denominator)
    }
}

extension Rational {
    /// Returns the result of multiplying `lhs` by `rhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `*`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    public static func &* (lhs: Rational, rhs: Rational) throws -> Rational {
        let (n1, d1) = lhs.asRatio
        let (n2, d2) = rhs.asRatio
        // n1   n2
        // -- * --
        // d1   d2
        //
        // let g1 = gcd(n1, d2)
        // let g2 = gcd(n2, d1)
        //
        // n1 * n2   (n1 / g1) * (n2 / g2)
        // ------- = ---------------------
        // d1 * d2   (d1 / g2) * (d2 / g1)
        //
        // We reduce n1/d2 and n2/d1 instead of
        // (n1 * n2)/(d1 * d2) to avoid overflow.
        return try Rational(n1, d2).multiplied(by: Rational(n2, d1))
    }
    
    /// Returns this value multiplied by `other`,
    /// throwing an error on overflow.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    internal func multiplied(by other: Rational) throws -> Rational {
        // See `*` for more details.
        let (numerator, overflow1) = self.numerator.multipliedReportingOverflow(by: other.numerator)
        let (denominator, overflow2) = self.denominator.multipliedReportingOverflow(by: other.denominator)
        guard !overflow1 && !overflow2 else { throw ArithmeticError.overflow }
        return Rational(numerator: numerator, denominator: denominator)
    }
}
