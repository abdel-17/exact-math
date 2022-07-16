import Foundation

extension Rational: LosslessStringConvertible {
    /// Creates a rational value from its string representation.
    ///
    /// The string may begin with a + or - character,
    /// followed by one or more digits (0-9), optionally
    /// followed by a / character and one or more digits.
    ///
    /// If the string is in an invalid format, or it describes
    /// a value that cannot be represented within this type,
    /// `nil` is returned. For example:
    ///
    /// ```
    ///     Rational<Int>(" 24")    // Whitespace.
    ///     Rational<Int>("2 / 3")  // Whitespace.
    ///     Rational<Int>("5/-2")   // Negative sign in the wrong place.
    ///     Rational<Int>("1/0")    // Invalid value.
    ///     Rational<Int8>("128/2") // 128 out of bounds for Int8.
    /// ```
    ///
    /// - Parameter description: The ASCII description of the value.
    public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
    /// Creates a rational value from its string representation.
    ///
    /// The string may begin with a + or - character,
    /// followed by one or more digits (0-9) and/or
    /// letters (a-z A-Z), optionally followed by a
    /// / character and one or more digits/letters.
    ///
    /// If the string is in an invalid format, the characters
    /// are out of bounds for the given radix, or it describes
    /// a value that cannot be represented within this type,
    /// `nil` is returned. For example:
    ///
    /// ```
    ///     Rational<Int>("900", radix: 8)  // "9" out of bounds for radix 8.
    ///     Rational<Int>(" 24")            // Whitespace.
    ///     Rational<Int>("2 / 3")          // Whitespace.
    ///     Rational<Int>("5/-2")           // Negative sign in the wrong place.
    ///     Rational<Int>("1/0")            // Division by zero.
    ///     Rational<Int8>("128/2")         // 128 out of bounds for Int8.
    /// ```
    ///
    /// - Parameters:
    ///   - description: The ASCII description of the value.
    ///   - radix: The radix (base) the value is described in.
    ///
    /// - Requires: `radix` in the range `2...36`.
    public init?(_ description: String, radix: Int = 10) {
        guard let result = description.parseRational() else { return nil }
        guard let numerator = IntegerType(result.numerator, radix: radix) else { return nil }
        guard let denominatorString = result.denominator else {
            self.init(numerator)
            return
        }
        guard let denominator = IntegerType(denominatorString, radix: radix),
              denominator != 0
        else { return nil }
        self.init(numerator, denominator)
    }
}

private let rationalRegex = try! NSRegularExpression(pattern: "(" +     // Capture {
                                                     "(?:\\+|-)?" +     //  Optionally { + or - }
                                                     "[0-9a-z]+" +      //  One or more digits/letters
                                                     ")" +              // }
                                                     "(?:" +            // Optionally {
                                                     "\\/" +            //  Fraction slash
                                                     "([0-9a-z]+)" +    //  Capture { One or more digits/letters }
                                                     ")?",              // }
                                                     options: .caseInsensitive)

private extension String {
    subscript(bounds: NSRange) -> Substring? {
        guard let range = Range(bounds, in: self) else { return nil }
        return self[range]
    }
    
    func parseRational() -> (numerator: Substring,
                             denominator: Substring?)? {
        // Match the entire string as a single pattern.
        let range = NSRange(startIndex..., in: self)
        guard let match = rationalRegex.firstMatch(in: self, range: range),
              match.range == range
        else { return nil }
        // Make sure there are exactly two capture groups.
        assert(match.numberOfRanges == 3)
        return (numerator: self[match.range(at: 1)]!,
                denominator: self[match.range(at: 2)])
    }
}
