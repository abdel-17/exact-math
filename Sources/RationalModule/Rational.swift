import RealModule

/// A rational number with a sign-magnitude representation.
///
/// All values of this type are reduced to their simplest form,
/// i.e. the numerator and denominator are coprime.
public struct Rational<IntegerType : UnsignedInteger & FixedWidthInteger> {
    /// The internal representation of the sign.
    ///
    /// Note: for the value zero, this property can be
    /// either `true` or `false`. Both are valid
    /// representations as the public `.sign`
    /// property returns `nil` for zero.
    @usableFromInline
    internal var hasNegativeSign: Bool
    
    /// The magnitude of the reduced numerator.
    public let numerator: IntegerType
    
    /// The magnitude of the reduced denominator.
    public let denominator: IntegerType
    
    /// Creates a rational value with the given properties.
    @inlinable
    internal init(hasNegativeSign: Bool,
                  numerator: IntegerType,
                  denominator: IntegerType) {
        assert(denominator != 0 &&
               gcd(numerator, denominator) == 1)
        self.hasNegativeSign = hasNegativeSign
        self.numerator = numerator
        self.denominator = denominator
    }
}

public extension Rational {
    /// Creates a rational value, reducing the given fraction.
    ///
    /// - Parameters:
    ///   - sign: The sign. Ignored if the value is zero.
    ///   - numerator: The magnitude of the fraction's numerator.
    ///   - denominator: The magnitude of the fraction's denominator.
    ///
    /// - Precondition: `denominator != 0`
    @inlinable
    init(sign: Sign = .plus,
         numerator: IntegerType,
         denominator: IntegerType) {
        precondition(denominator != 0)
        let (numerator, denominator) = reduced(numerator, denominator)
        self.init(hasNegativeSign: sign == .minus,
                  numerator: numerator,
                  denominator: denominator)
    }
    
    /// Creates a rational value.
    ///
    /// - Parameters:
    ///   - sign: The sign. Ignored if the value is zero.
    ///   - quotient: The magnitude of the quotient.
    ///   - remainder: The magnitude of the remainder.
    ///   - denominator: The magnitude of the denominator.
    ///
    /// - Precondition: `denominator != 0`
    @inlinable
    init(sign: Sign = .plus,
         quotient: IntegerType,
         remainder: IntegerType,
         denominator: IntegerType) {
        precondition(denominator != 0)
        // First reduce the fractional part.
        let (remainder, denominator) = reduced(remainder, denominator)
        //     r   q * d + r
        // q + - = ---------
        //     d       d
        self.init(hasNegativeSign: sign == .minus,
                  numerator: quotient * denominator + remainder,
                  denominator: denominator)
    }
    
    /// True iff this value is zero.
    @inlinable
    var isZero: Bool {
        numerator == 0
    }
    
    /// The sign, or `nil` if this value is zero.
    @inlinable
    var sign: Sign? {
        guard !isZero else { return nil }
        return hasNegativeSign ? .minus : .plus
    }
    
    /// A tuple of the numerator and denominator.
    @inlinable
    var fraction: (numerator: IntegerType,
                   denominator: IntegerType) {
        (numerator, denominator)
    }
    
    /// The magnitude of the quotient and remainder of
    /// dividing the numerator by the denominator.
    ///
    /// The quotient `q` and remainder `r` satisfy the
    /// relation `(n == q * d + r) && (r < d)`,
    /// where `n` and `d` are the numerator and
    /// denominator of this value.
    @inlinable
    var quotientAndRemainder: (quotient: IntegerType,
                               remainder: IntegerType) {
        numerator.quotientAndRemainder(dividingBy: denominator)
    }
    
    /// The sign of this value and the magnitude
    /// of the integral and fractional parts.
    ///
    /// The sign is `nil` If this value is zero.
    @inlinable
    var parts: (sign: Sign?,
                integral: IntegerType,
                fractional: (numerator: IntegerType,
                             denominator: IntegerType)) {
        let (q, r) = quotientAndRemainder
        return (sign, q, (r, denominator))
    }
}
