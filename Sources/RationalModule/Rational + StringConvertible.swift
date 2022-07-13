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
