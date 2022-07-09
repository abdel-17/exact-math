extension Rational: SignedNumeric {
    @inlinable
    public static func * (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs.multipliedOrThrows(by: rhs)
    }
    
    @inlinable
    public static func *= (lhs: inout Rational, rhs: Rational) {
        try! lhs.multiplyOrThrows(by: rhs)
    }
    
    @inlinable
    public var magnitude: Rational {
        var magnitude = self
        magnitude.isNegative = false
        return magnitude
    }
    
    @inlinable
    public mutating func negate() {
        isNegative.toggle()
    }
}

public extension Rational {
    /// Returns the result of multiplying this value by `other`.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `*`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    func multipliedOrThrows(by other: Rational) throws -> Rational {
        var (n1, d1) = self.fraction
        var (n2, d2) = other.fraction
        reduceFraction(&n1, &d2)
        reduceFraction(&n2, &d1)
        return try Rational(isNegative: self.isNegative != other.isNegative,
                            n1.multipliedOrThrows(by: n2),
                            d1.multipliedOrThrows(by: d2))
    }
    
    /// Multiplies this value by `other`.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `*=`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    mutating func multiplyOrThrows(by other: Rational) throws {
        self = try self.multipliedOrThrows(by: other)
    }
}
