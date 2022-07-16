extension Rational: Numeric {
    public static func * (lhs: Rational, rhs: Rational) -> Rational {
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
        // We reduce (n1, d2) and (n2, d1) instead of
        // (n1 * n2, d1 * d2) to avoid overflow.
        Rational(lhs.numerator, rhs.denominator).multiplied(by: Rational(rhs.numerator, lhs.denominator))
    }
    
    public static func *= (lhs: inout Rational, rhs: Rational) {
        lhs = lhs * rhs
    }
    
    /// Replaces this value with the additive inverse.
    ///
    /// If the numerator is `IntegerType.min`,
    /// the additive inverse cannot be represented.
    public mutating func negate() {
        self = Rational(numerator: -numerator, denominator: denominator)
    }
}

extension Rational {
    /// Returns this value multiplied by `other`.
    internal func multiplied(by other: Rational) -> Rational {
        // See * for more details.
        Rational(numerator: self.numerator * other.numerator,
                 denominator: self.denominator * other.denominator)
    }
    
    /// Returns this value multiplied by `other`,
    /// or throws an error on overflow.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    internal func multipliedOrThrows(by other: Rational) throws -> Rational {
        // See * for more details.
        let (numerator, overflow1) = self.numerator.multipliedReportingOverflow(by: other.numerator)
        let (denominator, overflow2) = self.denominator.multipliedReportingOverflow(by: other.denominator)
        guard !overflow1 && !overflow2 else { throw ArithmeticError.overflow }
        return Rational(numerator: numerator, denominator: denominator)
    }
    
    /// Returns the result of multiplying `lhs` by `rhs`,
    /// or throws an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `*`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    public static func &* (lhs: Rational, rhs: Rational) throws -> Rational {
        try Rational(lhs.numerator, rhs.denominator).multipliedOrThrows(by: Rational(rhs.numerator, lhs.denominator))
    }
}
