extension Rational: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        // We combine `sign` instead of `hasNegativeSign`
        // so that 0 and -0 hash to the same value.
        hasher.combine(sign)
        hasher.combine(numerator)
        hasher.combine(denominator)
    }
}
