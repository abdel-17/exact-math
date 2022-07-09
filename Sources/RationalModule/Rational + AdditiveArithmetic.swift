extension Rational: AdditiveArithmetic {
    @inlinable
    public static func + (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs.addingOrThrows(rhs)
    }
    
    @inlinable
    public static func += (lhs: inout Rational, rhs: Rational) {
        try! lhs.addOrThrows(rhs)
    }
    
    @inlinable
    public static func - (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs.subtractingOrThrows(rhs)
    }
    
    @inlinable
    public static func -= (lhs: inout Rational, rhs: Rational) {
        try! lhs.subtractOrThrows(rhs)
    }
}

public extension Rational {
    /// Returns the result of adding `other` to this value
    /// by forming a common denomnator.
    ///
    /// - Parameters:
    ///   - other: The value to add.
    ///   - lhsMultiplier: The value to multiply the
    ///   numerator and denominator of this value by.
    ///   - rhsMultiplier: The value to multiply the
    ///   numerator and denominator of `other` by.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @usableFromInline
    internal func formingCommonDenominator(with other: Rational,
                                           lhsMultiplier: IntegerType,
                                           rhsMultiplier: IntegerType) throws -> Rational {
        // n1   n2   n1 * m1   n2 * m2   n1 * m1 + n2 * m2
        // -- + -- = ------- + ------- = -----------------
        // d1   d2   d1 * m1   d2 * m2        d1 * m1
        assert(self.denominator * lhsMultiplier == other.denominator * rhsMultiplier)
        let lhsNumerator = try self.numerator.multipliedOrThrows(by: lhsMultiplier)
        let rhsNumerator = try other.numerator.multipliedOrThrows(by: rhsMultiplier)
        let (isNegative, numerator) = try lhsNumerator.addingOrThrows(isNegative: self.isNegative,
                                                                      other: rhsNumerator,
                                                                      otherIsNegative: other.isNegative)
        return try Rational(isNegative: isNegative,
                            numerator,
                            self.denominator.multipliedOrThrows(by: lhsMultiplier))
    }
    
    /// Returns the result of adding `other` to this value.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `+`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    func addingOrThrows(_ other: Rational) throws -> Rational {
        let d1 = self.denominator
        let d2 = other.denominator
        let g1 = gcd(d1, d2)
        // We form a common denominator using the least
        // common multiple function.
        //
        // lcm(d1, d2) = d1 * d2 / g1
        //
        // n1   n2
        // -- ± --
        // d1   d2
        //
        // The lhs is multiplied up and down by d2 / g1,
        // and the rhs by d1 / g1
        var m1 = d2
        var m2 = d1
        if g1 != 1 {
            m1 /= g1
            m2 /= g1
        }
        let result = try self.formingCommonDenominator(with: other,
                                                       lhsMultiplier: m1,
                                                       rhsMultiplier: m2)
        // For cases where the denominators are coprime,
        // the fraction does not need to be reduced.
        // This optimization is worth it because 61% of
        // randomly chosen integers are coprime.
        guard g1 != 1 else { return result }
        // gcd(numerator, denominator) = gcd(numerator, g1).
        // This is faster to compute as g1 will be less than
        // denominator (d1 * d2) in most cases.
        let g2 = gcd(result.numerator, g1)
        guard g2 != 1 else { return result }
        return Rational(isNegative: result.isNegative,
                        result.numerator / g2,
                        result.denominator / g2)
    }
    
    /// Adds`other` to this value.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `+=`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    mutating func addOrThrows(_ other: Rational) throws {
        self = try self.addingOrThrows(other)
    }
    
    /// Returns the result of subtracting `other` from this value.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `-`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    func subtractingOrThrows(_ other: Rational) throws -> Rational {
        try self.addingOrThrows(-other)
    }
    
    /// Subtracts `other` from this value.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `-=`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    mutating func subtractOrThrows(_ other: Rational) throws {
        self = try self.subtractingOrThrows(other)
    }
}
