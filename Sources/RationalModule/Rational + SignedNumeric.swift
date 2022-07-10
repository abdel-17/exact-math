extension Rational: SignedNumeric {
    public static func * (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs.multipliedOrThrows(by: rhs)
    }
    
    public static func *= (lhs: inout Rational, rhs: Rational) {
        try! lhs.multiplyOrThrows(by: rhs)
    }
    
    public var magnitude: Rational {
        var magnitude = self
        magnitude.isNegative = false
        return magnitude
    }
    
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
    func multipliedOrThrows(by other: Rational) throws -> Rational {
        var (n1, d1) = self.fraction
        var (n2, d2) = other.fraction
        reduceFraction(&n1, &d2)
        reduceFraction(&n2, &d1)
        return try Rational(isNegative: self.isNegative != other.isNegative,
                            numerator: n1.multipliedOrThrows(by: n2),
                            denominator: d1.multipliedOrThrows(by: d2))
    }
    
    /// Multiplies this value by `other`.
    ///
    /// Use this function when you want to check
    /// for overflow; otherwise, use `*=`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    mutating func multiplyOrThrows(by other: Rational) throws {
        self = try self.multipliedOrThrows(by: other)
    }
}
