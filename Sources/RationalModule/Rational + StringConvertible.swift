import Foundation

extension Rational: CustomStringConvertible {
    public var description: String {
        String(self, radix: 10)
    }
}

extension Rational: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Rational<\(IntegerType.self)>(\(numerator), \(denominator))"
    }
}

public extension String {
    /// Creates a string describing the given rational value.
    ///
    /// Numerals greater than 9 are represented as Roman letters.
    ///
    /// - Parameters:
    ///   - value: The value to convert to a string.
    ///   - radix: The radix (base) to describe the value in.
    ///   Default value is `10`. Must be in the range `2...36`.
    ///   - uppercase: Pass `true` to use uppercase letters.
    ///   Default value is `false`.
    @inlinable
    init<T>(_ value: Rational<T>, radix: Int = 10, uppercase: Bool = false) {
        let numerator = String(value.numerator, radix: radix, uppercase: uppercase)
        guard value.denominator != 1 else {
            self = numerator
            return
        }
        let denominator = String(value.denominator, radix: radix, uppercase: uppercase)
        self = "\(numerator)/\(denominator)"
    }
}

// MARK: - Regex

// Constructing an NSRegularExpression instance is expensive,
// so we store a reference to access directly.
internal extension NSRegularExpression {
    /// A regular expression that matches the rational pattern
    /// and captures its numerator and denominator.
    @usableFromInline
    static let rational = try! NSRegularExpression(pattern: "(" +
                                                   "(?:\\+|-)?" +     // Optional sign
                                                   "[0-9a-z]+" +      // One or more digit or letter
                                                   ")" +              //
                                                   "(?:" +            // Optionally:
                                                   "\\/" +            // - Fraction slash
                                                   "([0-9a-z]+)" +    // - One or more digit or letter
                                                   ")?",
                                                   options: .caseInsensitive)
}

internal extension String {
    /// Returns a substring of this value at the given bounds,
    /// or `nil` if the bounds are out of range.
    @inlinable
    subscript(bounds: NSRange) -> Substring? {
        guard let range = Range(bounds, in: self) else { return nil }
        return self[range]
    }
}

// MARK: - Conformance to LosslessStringConvertible
extension Rational: LosslessStringConvertible {
    /// Creates a rational value from its string representation.
    ///
    /// Equivalent to `Rational(description, radix: 10)`.
    ///
    /// - Parameter description: The ASCII description of the value.
    @inlinable
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
    @inlinable
    public init?(_ description: String, radix: Int = 10) {
        // Match the entire string as a single pattern.
        let range = NSRange(description.startIndex..., in: description)
        guard let match = NSRegularExpression.rational.firstMatch(in: description, range: range),
              match.range == range
        else { return nil }
        // Make sure there are exactly two capture groups.
        assert(match.numberOfRanges == 3)
        // The numerator is non-optional, so it's safe to force unwrap.
        let numeratorString = description[match.range(at: 1)]!
        // Guard against overflow and out-of-bounds characters.
        guard let numerator = IntegerType(numeratorString, radix: radix) else { return nil }
        // The denominator is optional.
        guard let denominatorString = description[match.range(at: 2)] else {
            // Handle the missing denominator case as an integer.
            self.init(numerator)
            return
        }
        guard let denominator = IntegerType(denominatorString, radix: radix) else { return nil }
        self.init(numerator, denominator)
    }
}
