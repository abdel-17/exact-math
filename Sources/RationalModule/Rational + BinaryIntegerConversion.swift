extension Rational: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = IntegerType.IntegerLiteralType
    
    @inlinable
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(IntegerType(integerLiteral: value))
    }
}

public extension Rational {
    /// Creates a rational value from an integer.
    ///
    /// Equivalent to creating a rational value whose
    /// numerator is `value` and denominator `1`.
    ///
    /// - Parameter value: The integer to convert to a rational value.
    @inlinable
    init(_ value: IntegerType) {
        self.init(numerator: value, denominator: 1)
    }
    
    /// Creates a rational value from an integer.
    ///
    /// Equivalent to `Rational(IntegerType(source))`.
    ///
    /// - Parameter source: The integer to convert to a rational value.
    @inlinable
    init<T : BinaryInteger>(_ source: T) {
        self.init(IntegerType(source))
    }
    
    /// Creates a rational value from an integer,
    /// returning `nil` if it cannot be represented
    /// exactly in `IntegerType`.
    ///
    /// Use this initializer if `source` might not be
    /// representible exactly in `IntegerType`;
    /// otherwise, use `init(_:)`.
    ///
    /// - Parameter source: The integer to convert to a rational value.
    @inlinable
    init?<T : BinaryInteger>(exactly source: T) {
        guard let value = IntegerType(exactly: source) else { return nil }
        self.init(value)
    }
}

public extension BinaryInteger {
    /// Creates an integer from truncating
    /// the given rational value.
    ///
    /// Equivalent to `Self(source.quotient)`.
    ///
    /// - Parameter source: The rational value to convert to an integer.
    @inlinable
    init<T>(_ source: Rational<T>) {
        self.init(source.quotient)
    }
    
    /// Creates an integer from the given rational value,
    /// returning `nil` if it cannot be represented
    /// exactly in this type.
    ///
    /// - Parameter source: The rational value to convert to an integer.
    @inlinable
    init?<T>(exactly source: Rational<T>) {
        guard source.denominator == 1,
              let value = Self(exactly: source.numerator)
        else { return nil }
        self.init(value)
    }
}
