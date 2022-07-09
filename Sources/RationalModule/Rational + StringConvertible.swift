extension Rational: CustomStringConvertible {
    public var description: String {
        // Return "0" regardless of the sign.
        guard !isZero else { return "0" }
        let magnitude = denominator == 1 ? String(numerator) : "\(numerator)/\(denominator)"
        return isNegative ? "-\(magnitude)" : magnitude
    }
}

extension Rational: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Rational<\(IntegerType.self)>(sign: \(String(describing: sign)), \(numerator), \(denominator))"
    }
}
