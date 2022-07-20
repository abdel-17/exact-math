// We implement `Equatable` manually because the synthesized
// implementation conflicts with the one from `Strideable`.
extension Rational: Equatable {
    public static func == (lhs: Rational, rhs: Rational) -> Bool {
        lhs.numerator == rhs.numerator &&
        lhs.denominator == rhs.denominator
    }
}

extension Rational: Strideable {
    public func advanced(by n: Rational) -> Rational {
        self + n
    }
    
    public func distance(to other: Rational) -> Rational {
        other - self
    }
}
