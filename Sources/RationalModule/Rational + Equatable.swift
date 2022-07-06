extension Rational: Equatable {
    @inlinable
    public static func == (lhs: Rational, rhs: Rational) -> Bool {
        // Zero values compare equal regardless of
        // their internal sign representation.
        guard !lhs.isZero else { return rhs.isZero }
        return lhs.isNegative == rhs.isNegative &&
        lhs.numerator == rhs.numerator &&
        lhs.denominator == rhs.denominator
    }
}
