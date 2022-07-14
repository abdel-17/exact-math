extension Rational: AdditiveArithmetic {
    public static func + (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs &+ rhs
    }
    
    public static func - (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs &- rhs
    }
}

public extension Rational {
    /// Returns the result of forming a common denominator
    /// with `other` and combining the numerators using
    /// the given closure.
    ///
    /// - Throws: `ArithmeticError` on overflow.
    internal func formingCommonDenominator(with other: Rational,
                                           operation: (IntegerType, IntegerType) throws -> IntegerType) throws -> Rational {
        let (n1, d1) = self.numeratorAndDenominator
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
        var lhsMultiplier = d2
        var rhsMultiplier = d1
        divide(&lhsMultiplier, &rhsMultiplier, by: g1)
        var numerator = try operation(multiplyThrowingOnOverflow(n1, lhsMultiplier),
                                      multiplyThrowingOnOverflow(n2, rhsMultiplier))
        var denominator = try multiplyThrowingOnOverflow(d1, lhsMultiplier)
        // If the denominators are coprime,
        // the fraction is reduced.
        if g1 != 1 {
            // gcd(numerator, denominator) = gcd(numerator, g1).
            // This is faster to compute as g1 is less than
            // denominator (d1 * d2) in most cases.
            let g2 = gcd(numerator, g1)
            divide(&numerator, &denominator, by: g2)
        }
        return Rational(numerator: numerator, denominator: denominator)
    }
    
    /// Returns the result of adding `rhs` to `lhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `+`.
    ///
    /// - Throws: `ArithmeticError` on overflow.
    static func &+ (lhs: Rational, rhs: Rational) throws -> Rational {
        try lhs.formingCommonDenominator(with: rhs,
                                         operation: addThrowingOnOverflow)
    }
    
    /// Returns the result of subtracting `rhs` from `lhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `-`.
    ///
    /// - Throws: `ArithmeticError` on overflow.
    static func &- (lhs: Rational, rhs: Rational) throws -> Rational {
        try lhs.formingCommonDenominator(with: rhs,
                                         operation: subtractThrowingOnOverflow)
    }
    
    /// Adds `rhs` to `lhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `+=`.
    ///
    /// - Throws: `ArithmeticError` on overflow.
    static func &+= (lhs: inout Rational, rhs: Rational) throws {
        try lhs = lhs &+ rhs
    }
    
    /// Subtracts `rhs` from `lhs`,
    /// throwing an error on overflow.
    ///
    /// Use this operator when you want to check
    /// for overflow; otherwise, use `-=`.
    ///
    /// - Throws: `ArithmeticError` on overflow.
    static func &-= (lhs: inout Rational, rhs: Rational) throws {
        try lhs = lhs &- rhs
    }
}
