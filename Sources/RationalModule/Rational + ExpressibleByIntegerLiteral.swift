extension Rational: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = IntegerType.IntegerLiteralType
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(IntegerType(integerLiteral: value))
    }
}

public extension Rational {
    /// The maximum representible rational value.
    ///
    /// Equivalent to `Rational(IntegerType.max)`.
    static var max: Rational {
        Rational(IntegerType.max)
    }
    
    /// The rational value with numerator 0
    /// and denominator 1.
    ///
    /// Equivalent to `Rational(IntegerType.zero)`.
    static var zero: Rational {
        Rational(IntegerType.zero)
    }
    
    /// The rational value with numerator and
    /// denominator both 1.
    ///
    /// Equivalent to `Rational(1 as IntegerType)`.
    @inlinable
    static var one: Rational {
        Rational(1 as IntegerType)
    }
    
    /// Creates a rational value from a sign-magnitude
    /// representation of an integer.
    ///
    /// Use this initializer when you want to specify the
    /// sign of a value created from an unsigned integer.
    ///
    /// - Parameters:
    ///   - sign: The sign. Ignored if the value is zero.
    ///   Default value is `.plus`.
    ///   - numerator: The magnitude of the integer.
    init(sign: Sign = .plus,
         _ magnitude: IntegerType) {
        self.init(isNegative: sign == .minus,
                  magnitude, 1)
    }
    
    /// Creates a rational value from an integer.
    ///
    /// Use this initializer when you're sure the magnitude of
    /// `source` can be represented in `IntegerType`,
    /// otherwise a runtime error will occur.
    ///
    /// Use `init?(exactly:)` to return `nil`
    /// instead of a runtime error.
    init<T : BinaryInteger>(_ source: T) {
        self.init(isNegative: T.isSigned && source < 0,
                  IntegerType(source.magnitude), 1)
    }
    
    /// Creates a rational value from an integer,
    /// or `nil` if it cannot be represented exactly.
    ///
    /// Use this initializer when you're unsure if the magnitude of
    /// `source` can be represented exactly in `IntegerType`.
    init?<T : BinaryInteger>(exactly source: T) {
        guard let magnitude = IntegerType(exactly: source.magnitude) else { return nil }
        self.init(isNegative: T.isSigned && source < 0,
                  magnitude, 1)
    }
    
    /// Creates a rational value, reducing the given fraction.
    ///
    /// Use this initializer to create a rational value from
    /// a fraction of integers, if they can be represented
    /// in this type.
    ///
    /// - Parameters:
    ///   - numerator: The numerator of the fraction.
    ///   - denominator: The denominator of the fraciton.
    init<T : BinaryInteger>(_ numerator: T,
                            _ denominator: T) {
        // This incorrectly considers the value negative
        // if the numerator is zero, but that's okay as
        // 0 and -0 are considered the same value.
        self.init(isNegative: T.isSigned && numerator.signum() != denominator.signum(),
                  IntegerType(numerator.magnitude),
                  IntegerType(denominator.magnitude),
                  reduce: true)
    }
}
