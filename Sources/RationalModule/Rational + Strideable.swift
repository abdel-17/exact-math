extension Rational: Strideable {
    public func advanced(by n: Rational) -> Rational {
        self + n
    }
    
    public func distance(to other: Rational) -> Rational {
        other - self
    }
}
