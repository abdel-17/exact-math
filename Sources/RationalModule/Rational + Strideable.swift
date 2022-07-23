// We implement `Equatable` manually because the synthesized
// implementation conflicts with the one from `Strideable`.
extension Rational: Equatable {
    @inlinable
    public static func == (lhs: Rational, rhs: Rational) -> Bool {
        lhs.numerator == rhs.numerator &&
        lhs.denominator == rhs.denominator
    }
}

extension Rational: Strideable {
    @inlinable
    public func advanced(by n: Rational) -> Rational {
        self + n
    }
    
    @inlinable
    public func distance(to other: Rational) -> Rational {
        other - self
    }
}
