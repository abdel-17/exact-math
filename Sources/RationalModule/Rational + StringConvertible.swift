import Foundation

extension Rational: CustomStringConvertible {
    public var description: String {
        denominator == 1 ? "\(numerator)" : "\(numerator)/\(denominator)"
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
    ///   Default value is `10`.
    ///   - uppercase: Pass `true` to use uppercase letters.
    ///   Default value is `false`. Must be in the range `2...36`.
    public init<T>(_ value: Rational<T>, radix: Int = 10, uppercase: Bool = false) {
        let numerator = String(value.numerator, radix: radix, uppercase: uppercase)
        guard value.denominator != 1 else {
            self = numerator
            return
        }
        let denominator = String(value.denominator, radix: radix, uppercase: uppercase)
        self = "\(numerator)/\(denominator)"
    }
}

extension Rational: LosslessStringConvertible {
    /// Creates a rational value from its string representation.
    ///
    /// Equivalent to `Rational(description, radix: 10)`.
    ///
    /// - Parameter description: The ASCII decimal description of the value.
    public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
    /// Creates a rational value from its string representation
    /// in the given radix.
    ///
    /// The string may begin with a + or - character,
    /// followed by one or more digits (0-9) and/or
    /// letters (a-z or A-Z), optionally followed by a
    /// / character and one or more digits/letters.
    ///
    /// If the string is in an invalid format, the characters
    /// are out of bounds for the given radix, or it describes
    /// a value that cannot be represented within this type,
    /// `nil` is returned. For example:
    ///
    /// ```
    ///     Rational<Int>("800", radix: 8)  // "8" out of bounds for radix 8.
    ///     Rational<Int>("2 / 3")          // Whitespace.
    ///     Rational<Int>("5/-2")           // Negative sign in the wrong place.
    ///     Rational<Int>("1/0")            // Division by zero.
    ///     Rational<Int8>("128/2")         // 128 out of bounds for Int8.
    ///     Rational<Int>("+1/3-2/3")       // Does not match 1 rational pattern.
    /// ```
    ///
    /// - Parameters:
    ///   - description: The ASCII description of the value.
    ///   - radix: The radix (base) the value is described in.
    ///   Default value is 10. Must be in the range `2...36`.
    public init?(_ description: String, radix: Int = 10) {
        // Check if `description` matches the pattern.
        guard let result = description.parseRational() else { return nil }
        // Guard against overflow and invalid characters for the radix.
        guard let numerator = IntegerType(result.numerator, radix: radix) else { return nil }
        guard let denominatorString = result.denominator else {
            // Handle this case as an integer.
            self.init(numerator)
            return
        }
        // Guard against overflow and invalid characters for the radix.
        guard let denominator = IntegerType(denominatorString, radix: radix),
              denominator != 0
        else { return nil }
        self.init(numerator, denominator)
    }
}

private extension NSRegularExpression {
    /// A regular expression that matches the rational pattern
    /// and captures its numerator and denominator.
    static let rational = try! NSRegularExpression(pattern: "(" +     // Capture {
                                                   "(?:\\+|-)?" +     //  Optional sign
                                                   "[0-9a-z]+" +      //  One or more digit or letter
                                                   ")" +              // }
                                                   "(?:" +            // Optional {
                                                   "\\/" +            //  Fraction slash
                                                   "([0-9a-z]+)" +    //  Capture { One or more digit or letter }
                                                   ")?",              // }
                                                   options: .caseInsensitive)
}

private extension String {
    /// Returns a substring of this value at the given bounds,
    /// or `nil` if the bounds are out of range.
    subscript(bounds: NSRange) -> Substring? {
        guard let range = Range(bounds, in: self) else { return nil }
        return self[range]
    }
    
    /// Parses this value into a rational number,
    /// or `nil` if it does not match the pattern.
    func parseRational() -> (numerator: Substring,
                             denominator: Substring?)? {
        // Match the entire string as a single pattern.
        let range = NSRange(startIndex..., in: self)
        guard let match = NSRegularExpression.rational.firstMatch(in: self, range: range),
              match.range == range
        else { return nil }
        // Make sure there are exactly two capture groups.
        assert(match.numberOfRanges == 3)
        return (numerator: self[match.range(at: 1)]!,
                denominator: self[match.range(at: 2)])
    }
}
