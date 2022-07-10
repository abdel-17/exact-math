import Foundation

private let regex = try! NSRegularExpression(pattern: "(\\+|-)?" +          // Optional sign.
                                             "([0-9]+|[a-z]+)" +            // One or more digits/letters.
                                             "(?:" +                        // Optionally:
                                             "\\/" +                        // - Fraction slash.
                                             "([0-9]+|[a-z]+)" +            // - One or more digits/letters.
                                             ")?",
                                             options: .caseInsensitive)

extension Rational: LosslessStringConvertible {
    /// Converts the given string to a rational value.
    ///
    /// The string may begin with a + or - character,
    /// followed by one or more digits (0-9), and
    /// optionally followed by a / character and
    /// one or more digits.
    ///
    /// If the string is in an invalid format, or describes
    /// a value that cannot be represented within this
    /// type, `nil` is returned.
    ///
    /// ```
    ///     Rational<UInt>(" 24")    // Whitespace.
    ///     Rational<UInt>("2 / 3")  // Whitespace.
    ///     Rational<UInt>("5/-2")   // Negative sign in the wrong place.
    ///     Rational<UInt>("1/0")    // Invalid value.
    ///     Rational<UInt8>("256/2") // 256 out of bounds for UInt8.
    /// ```
    ///
    /// - Parameter description: The ASCII description of the value.
    public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
    /// Converts the given string to a rational value.
    ///
    /// The string may begin with a + or - character,
    /// followed by one or more digits (0-9) and/or
    /// letters (a-zA-Z), and optionally followed by a
    /// / character and one or more digits/letters.
    ///
    /// If the string is in an invalid format, the characters
    /// are out of bounds for the given radix, or describes
    /// a value that cannot be represented within this type,
    /// `nil` is returned.
    ///
    /// ```
    ///     Rational<UInt>("900", radix: 8)     // "9" out of bounds for radix 8.
    ///     Rational<UInt>(" 24", radix: 10)    // Whitespace.
    ///     Rational<UInt>("2 / 3", radix: 10)  // Whitespace.
    ///     Rational<UInt>("5/-2", radix: 10)   // Negative sign in the wrong place.
    ///     Rational<UInt>("1/0", radix: 10)    // Division by zero.
    ///     Rational<UInt8>("256/2", radix: 10) // 256 out of bounds for UInt8.
    /// ```
    ///
    /// - Parameters:
    ///   - description: The ASCII description of the value.
    ///   - radix: The radix (base) the value is described in.
    ///
    /// - Requires: `radix` in the range `2...36`.
    public init?(_ description: String, radix: Int) {
        // Make sure the entire string matches to one pattern.
        let range = NSRange(description.startIndex..., in: description)
        guard let match = regex.firstMatch(in: description, range: range),
              match.range == range
        else { return nil }
        // Capture the sign, numerator, and denominator.
        let captures = (1...3).map { i -> Substring? in
            // The sign and denominator are optional.
            guard let bounds = Range(match.range(at: i), in: description) else { return nil }
            return description[bounds]
        }
        let sign = captures[0]
        // The numerator is not optional, so it's safe to force unwrap.
        // We still use guard let because the result is `nil` on overflow.
        guard let numerator = IntegerType(captures[1]!, radix: radix) else { return nil }
        // The denominator is optional. Handle the missing case as an integer.
        guard let denominatorString = captures[2] else {
            self.init(isNegative: sign == "-",
                      magnitude: numerator)
            return
        }
        // Check for zero division and overflow.
        guard let denominator = IntegerType(denominatorString, radix: radix),
              denominator != 0
        else { return nil }
        self.init(isNegative: sign == "-",
                  numerator: numerator,
                  denominator: denominator,
                  reduce: true)
    }
}
