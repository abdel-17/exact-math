extension Rational: CustomStringConvertible {
    public var description: String {
        "\(numerator)/\(denominator)"
    }
}

extension Rational: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Rational<\(IntegerType.self)>(\(numerator), \(denominator))"
    }
}

extension String {
    /// Creates a string describing the given rational value.
    ///
    /// Numerals greater than 10 are represented as Roman letters.
    ///
    /// - Parameters:
    ///   - value: The value to convert to a string.
    ///   - radix: The radix (base) to describe the value in.
    ///   Default value is 10.
    ///   - uppercase: True iff the letters are uppercased.
    ///   Default value is false. Must be in the range `2...36`.
    public init<T>(_ value: Rational<T>, radix: Int = 10, uppercase: Bool = false) {
        let numerator = String(value.numerator, radix: radix, uppercase: uppercase)
        let denominator = String(value.denominator, radix: radix, uppercase: uppercase)
        self = "\(numerator)/\(denominator)"
    }
}
