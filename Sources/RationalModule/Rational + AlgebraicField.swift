import RealModule

extension Rational: AlgebraicField {
    @inlinable
    public static func / (lhs: Rational, rhs: Rational) -> Rational {
        try! lhs.dividedOrThrows(by: rhs)
    }
    
    @inlinable
    public static func /= (lhs: inout Rational, rhs: Rational) {
        try! lhs.divideOrThrows(by: rhs)
    }
    
    /// The reciprocal of this value,
    /// or `nil` if it's zero.
    @inlinable
    public var reciprocal: Rational? {
        guard !isZero else { return nil }
        return Rational(isNegative: isNegative,
                        denominator,
                        numerator)
    }
}

public extension Rational {
    /// Returns the result of dividing this value by `other`.
    ///
    /// Use this function when you want to check for
    /// overflow or division by zero; otherwise, use `/`.
    ///
    /// - Throws: `ArithmeticError.zeroDivision` if `other` is zero;
    /// otherwise, `ArithmeticError.overflow` on overflow.
    @inlinable
    func dividedOrThrows(by other: Rational) throws -> Rational {
        guard let reciprocal = other.reciprocal else {
            throw ArithmeticError.zeroDivision
        }
        return try self.multipliedOrThrows(by: reciprocal)
    }
    /// Divides this value by `other`.
    ///
    /// Use this function when you want to check for
    /// overflow or division by zero; otherwise, use `/=`.
    ///
    /// - Throws: `ArithmeticError.zeroDivision` if `other` is zero;
    /// otherwise, `ArithmeticError.overflow` on overflow.
    @inlinable
    mutating func divideOrThrows(by other: Rational) throws {
        self = try self.dividedOrThrows(by: other)
    }
}
