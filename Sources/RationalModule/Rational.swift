import RealModule

/// A value type representing a rational number.
///
/// All `Rational `values are reduced to their simplest form,
/// i.e. the numerator and denominator are coprime.
public struct Rational<IntegerType : SignedInteger & FixedWidthInteger>: Hashable {
    /// The reduced numerator.
    ///
    /// The sign of a rational value is determined
    /// by the sign of its numerator.
    public let numerator: IntegerType
    
    /// The non-negative reduced denominator.
    ///
    /// This value is always non-zero. Attempting to
    /// create a rational value with zero denominator
    /// causes a runtime error.
    public let denominator: IntegerType
    
    /// Creates a rational value with the given properties.
    internal init(numerator: IntegerType,
                  denominator: IntegerType) {
        assert(denominator > 0 && gcd(numerator, denominator) == 1)
        self.numerator = numerator
        self.denominator = denominator
    }
}

// MARK: - Initializers
public extension Rational {
    /// Creates a rational value from a fraction of integers.
    ///
    /// - Parameters:
    ///   - numerator: The numerator of the fraction.
    ///   - denominator: The denominator of the fraction.
    ///
    /// - Precondition: `denominator != 0`
    init(_ numerator: IntegerType,
         _ denominator: IntegerType) {
        precondition(denominator != 0, "Cannot create a rational value with denominator zero.")
        // gcd(IntegerType.min, IntegerType.min)
        // and gcd(0, IntegerType.min) overflow
        // so we handle these cases separately.
        switch (numerator, denominator) {
        case (IntegerType.min, IntegerType.min):
            self = .one
        case (0, _):
            self = .zero
        default:
            var (numerator, denominator) = (numerator, denominator)
            reduceFraction(&numerator, &denominator)
            if denominator < 0 {
                numerator.negate()
                denominator.negate()
            }
            self.init(numerator: numerator,
                      denominator: denominator)
        }
    }
    
    /// Creates a rational value from a mixed number.
    ///
    /// - Parameters:
    ///   - integral: The integral part.
    ///   - fractional: The fractional part.
    init(integral: IntegerType,
         fractional: Rational) {
        //     r   q * d + r
        // q + - = ---------
        //     d       d
        // Since the fractional part is reduced,
        // the resulting fraction is reduced.
        self.init(numerator: integral * fractional.denominator + fractional.numerator,
                  denominator: fractional.denominator)
    }
    
    /// Creates a rational value from an integer.
    ///
    /// - Parameter value: The value as an integer.
    init(_ value: IntegerType) {
        self.init(numerator: value,
                  denominator: 1)
    }
    
    /// Creates a rational value from an integer.
    ///
    /// Use this initializer if `source` can be
    /// represented exactly in `IntegerType`,
    /// or else a runtime error will occur.
    ///
    /// Use `init?(exactly:)` to return `nil`
    /// instead of a runtime error.
    init<T : BinaryInteger>(_ source: T) {
        self.init(IntegerType(source))
    }
    
    /// Creates a rational value from an integer, returning
    /// `nil` if it cannot be represented exactly.
    ///
    /// Use this initializer if `source` may not be
    /// representible exactly in `IntegerType`;
    /// otherwise, use `init(_:)`.
    init?<T : BinaryInteger>(exactly source: T) {
        guard let value = IntegerType(exactly: source) else { return nil }
        self.init(value)
    }
}

// MARK: - Properties
public extension Rational {
    /// The minimum representible rational value.
    ///
    /// Equivalent to `Rational(IntegerType.min)`.
    static var min: Rational {
        Rational(IntegerType.min)
    }
    
    /// The maximum representible rational value.
    ///
    /// Equivalent to `Rational(IntegerType.max)`.
    static var max: Rational {
        Rational(IntegerType.max)
    }
    
    /// The rational value with numerator 0
    /// and denominator 1.
    ///
    /// Equivalent to `Rational(0 as IntegerType)`.
    static var zero: Rational {
        Rational(0 as IntegerType)
    }
    
    /// The rational value with numerator and
    /// denominator both 1.
    ///
    /// Equivalent to `Rational(1 as IntegerType)`.
    static var one: Rational {
        Rational(1 as IntegerType)
    }
    
    /// A tuple of the numerator and denominator.
    ///
    /// Use this value when you want to destructure
    /// a rational value to its components
    ///
    /// ```
    ///     let x = Rational(1, 2)
    ///     let (n, d) = x.numeratorAndDenominator  // (1, 2)
    /// ```
    var numeratorAndDenominator: (numerator: IntegerType,
                                  denominator: IntegerType) {
        (numerator, denominator)
    }
    
    /// True iff this value is zero.
    ///
    /// A rational value is zero iff
    /// its numerator is zero.
    var isZero: Bool {
        numerator == 0
    }
    
    /// True iff this value is negative.
    ///
    /// A rational value is negative iff
    /// its numerator is negative.
    var isNegative: Bool {
        numerator < 0
    }
    
    /// The sign of this value represented by an integer.
    ///
    /// This property is `1` if this value is positive,
    /// `-1` if it is negative, and `0` otherwise.
    var signum: IntegerType {
        numerator.signum()
    }
    
    /// The quotient of dividing the numerator
    /// by the denominator.
    ///
    /// Equivalent to the integral part.
    var quotient: IntegerType {
        numerator / denominator
    }
    
    /// The remainder of dividing the numerator
    /// by the denominator.
    ///
    /// Equivalent to the numerator of the fractional part.
    var remainder: IntegerType {
        numerator % denominator
    }
    
    /// The quotient and remainder of dividing
    /// the numerator by the denominator.
    ///
    /// The quotient `q` and remainder `r`of `n/d` satisfy
    /// the relation `(n == q * d + r) && abs(r) < d`.
    var quotientAndRemainder: (quotient: IntegerType,
                               remainder: IntegerType) {
        numerator.quotientAndRemainder(dividingBy: denominator)
    }
    
    /// The magnitude of this value.
    ///
    /// If the numerator is `IntegerType.min`,
    /// the magnitude cannot be represented.
    var magnitude: Rational {
        Rational(numerator: abs(numerator),
                 denominator: denominator)
    }
    
    /// The multiplicative inverse, if it can be represented.
    ///
    /// The reciprocal is `nil` if this value is zero
    /// or the numerator is `IntegerType.min`.
    var reciprocal: Rational? {
        guard !isZero && numerator != .min else { return nil }
        var (numerator, denominator) = (numerator, denominator)
        if numerator < 0 {
            numerator.negate()
            denominator.negate()
        }
        return Rational(numerator: denominator,
                        denominator: numerator)
    }
    
    /// The integral and fractional parts.
    var mixed: (integral: IntegerType,
                fractional: Rational) {
        let (quotient, remainder) = quotientAndRemainder
        let fractional = Rational(numerator: remainder,
                                  denominator: denominator)
        return (quotient, fractional)
    }
}

/*
// MARK: - Random
public extension Rational {
    static func random(in range: Range<Rational>) -> Rational {
        precondition(!range.isEmpty)
    }
}

*/
