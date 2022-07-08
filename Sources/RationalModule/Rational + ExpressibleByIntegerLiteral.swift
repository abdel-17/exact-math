extension Rational: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = IntegerType.IntegerLiteralType
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(magnitude: IntegerType(integerLiteral: value))
    }
}

public extension Rational {
    /// Creates a rational value from a sign-magnitude
    /// representation of an integer.
    ///
    /// - Parameters:
    ///   - sign: The sign. Ignored if the value is zero.
    ///   - numerator: The magnitude of the integer.
    @inlinable
    init(sign: Sign = .plus,
         magnitude: IntegerType) {
        self.init(isNegative: sign == .minus,
                  numerator: magnitude,
                  denominator: 1)
    }
    
    /// Creates a rational value from an integer.
    ///
    /// - Parameter source: The integer to convert to a rational value.
    @inlinable
    init<T : BinaryInteger>(_ source: T) {
        self.init(sign: (T.isSigned && source < 0) ? .minus : .plus,
                  magnitude: IntegerType(source.magnitude))
    }
    
    /// Creates a rational value from an integer,
    /// or `nil` if it cannot be represented exactly.
    ///
    /// - Parameter source: The integer to convert to a rational value.
    @inlinable
    init?<T : BinaryInteger>(exactly source: T) {
        guard let magnitude = IntegerType(exactly: source.magnitude) else { return nil }
        self.init(sign: (T.isSigned && source < 0) ? .minus : .plus,
                  magnitude: magnitude)
    }
    
    /// Creates a rational value, reducing the given fraction.
    ///
    /// - Parameters:
    ///   - numerator: The numerator of the fraction.
    ///   - denominator: The denominator of the fraciton.
    @inlinable
    init<T : BinaryInteger>(numerator: T,
                            denominator: T) {
        let isNegative = T.isSigned && numerator.signum() != denominator.signum()
        self.init(sign: isNegative ? .minus : .plus,
                  numerator: IntegerType(numerator.magnitude),
                  denominator: IntegerType(denominator.magnitude))
    }
}
