// We implement `Equatable` ourselves because
// the synthesized implementation conflicts
// with the one from `Strideable`.
extension Rational: Equatable {
    public static func == (lhs: Rational, rhs: Rational) -> Bool {
        lhs.numerator == rhs.numerator &&
        lhs.denominator == rhs.denominator
    }
}
