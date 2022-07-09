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
    internal var isNegative: Bool
    
    /// The magnitude of the reduced numerator.
    public let numerator: IntegerType
    
    /// The magnitude of the reduced denominator.
    ///
    /// This value is always non-zero. Attempting to
    /// create a rational value with zero denominator
    /// causes a runtime error.
    public let denominator: IntegerType
    
    /// Creates a rational value with the given properties,
    /// and a flag to check if the value needs to be reduced.
    ///
    /// The given fraction is assumed to be reduced.
    @usableFromInline
    internal init(isNegative: Bool,
                  _ numerator: IntegerType,
                  _ denominator: IntegerType,
                  reduce: Bool = false) {
        assert(denominator != 0)
        var (numerator, denominator) = (numerator, denominator)
        if reduce {
            reduceFraction(&numerator, &denominator)
        } else {
            assert(gcd(numerator, denominator) == 1)
        }
        self.isNegative = isNegative
        self.numerator = numerator
        self.denominator = denominator
    }
}

public extension Rational {
    /// The sign of a non-zero number.
    enum Sign {
        /// The sign of positive numbers.
        case plus
        
        /// The sign of negative numbers.
        case minus
        
        /// The sign opposite to this value.
        @inlinable
        public var opposite: Sign {
            switch self {
            case .plus:
                return .minus
            case .minus:
                return .plus
            }
        }
    }
    
    /// Creates a rational value, reducing the given fraction.
    ///
    /// Use this intializer to create a rational value from a
    /// fraction of integers with the given sign.
    ///
    /// - Parameters:
    ///   - sign: The sign. Default value is `.plus`.
    ///   Ignored if `numerator` is zero.
    ///   - numerator: The numerator of the fraction.
    ///   - denominator: The denominator of the fraction..
    ///
    /// - Precondition: `denominator != 0`
    @inlinable
    init(sign: Sign = .plus,
         _ numerator: IntegerType,
         _ denominator: IntegerType) {
        precondition(denominator != 0)
        self.init(isNegative: sign == .minus,
                  numerator,
                  denominator,
                  reduce: true)
    }
    
    /// Creates a rational value from a mixed number.
    ///
    /// Use this initializer to create a rational value from a
    /// mixed number with the given sign.
    ///
    /// - Parameters:
    ///   - sign: The sign. Default value is `.plus`.
    ///   Ignored if both `quotient` and `remaidner` are zero.
    ///   - quotient: The integral part.
    ///   - remainder: The numerator of the fractional part.
    ///   - denominator: The denominator of the fractional part.
    ///
    /// - Precondition: `denominator != 0`
    @inlinable
    init(sign: Sign = .plus,
         quotient: IntegerType,
         remainder: IntegerType,
         denominator: IntegerType) {
        precondition(denominator != 0)
        // First reduce the fractional part.
        var (remainder, denominator) = (remainder, denominator)
        reduceFraction(&remainder, &denominator)
        self.init(isNegative: sign == .minus,
                  quotient * denominator + remainder,
                  denominator)
    }
    
    /// True iff this value is zero.
    ///
    /// A rational value is zero iff its numerator is zero.
    @inlinable
    var isZero: Bool {
        numerator == 0
    }
    
    /// The sign, or `nil` if this value is zero.
    @inlinable
    var sign: Sign? {
        guard !isZero else { return nil }
        return isNegative ? .minus : .plus
    }
    
    /// The magnitude of the numerator and denominator.
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
}
