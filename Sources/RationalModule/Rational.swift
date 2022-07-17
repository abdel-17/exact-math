import RealModule

/// A rational number represented by its numerator and denominator.
///
/// All `Rational` values are reduced to their simplest form,
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
    
    /// Creates a rational value from a reduced fraction.
    @inlinable
    internal init(numerator: IntegerType, denominator: IntegerType) {
        precondition(denominator > 0)
        // This is an expensive check, so we use assert.
        assert(gcd(numerator, denominator) == 1)
        self.numerator = numerator
        self.denominator = denominator
    }
}

// MARK: - Initializers
public extension Rational {
    /// Creates a rational value from a fraction of integers.
    ///
    /// If the denominator is `IntegerType.min` and the
    /// numerator is odd, the value cannot be represented.
    ///
    /// - Parameters:
    ///   - numerator: The numerator of the fraction.
    ///   - denominator: The denominator of the fraction.
    ///
    /// - Precondition: `denominator != 0`
    @inlinable
    init(_ numerator: IntegerType, _ denominator: IntegerType) {
        precondition(denominator != 0, "Cannot create a rational value with denominator zero.")
        // gcd(IntegerType.min, IntegerType.min) and gcd(0, IntegerType.min)
        // overflow (the magnitude of .min cannot be represented).
        switch (numerator, denominator) {
        case (.min, .min):
            self = .one
        case (0, _):
            self = .zero
        default:
            let g = gcd(numerator, denominator)
            var (numerator, denominator) = (numerator / g, denominator / g)
            if denominator < 0 {
                numerator.negate()
                denominator.negate()
            }
            self.init(numerator: numerator, denominator: denominator)
        }
    }
    
    /// Creates a rational value from a mixed number.
    ///
    /// - Parameters:
    ///   - integral: The integral part.
    ///   - fractional: The fractional part.
    init(integral: IntegerType, fractional: Rational) {
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
        self.init(numerator: value, denominator: 1)
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
    var numeratorAndDenominator: (numerator: IntegerType, denominator: IntegerType) {
        (numerator, denominator)
    }
    
    /// True iff this value is a proper fraction.
    ///
    /// A fraction is proper iff its magnitude
    /// is less than 1.
    var isProper: Bool {
        numerator.magnitude < denominator.magnitude
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
    /// the relation `(n == q * d + r) && |r| < d`.
    var quotientAndRemainder: (quotient: IntegerType, remainder: IntegerType) {
        numerator.quotientAndRemainder(dividingBy: denominator)
    }
    
    /// The mixed number representation of this value.
    ///
    /// Use this property when you want to calculate the
    /// integral and fractional parts at the same time.
    var mixed: (integral: IntegerType, fractional: Rational) {
        let (quotient, remainder) = quotientAndRemainder
        let fractional = Rational(numerator: remainder, denominator: denominator)
        return (quotient, fractional)
    }
    
    /// The magnitude of this value.
    ///
    /// If the numerator is `IntegerType.min`,
    /// the magnitude cannot be represented.
    var magnitude: Rational {
        Rational(numerator: abs(numerator), denominator: denominator)
    }
    
    /// The multiplicative inverse, if it can be represented.
    ///
    /// The reciprocal is `nil` if this value is zero
    /// or the numerator is `IntegerType.min`.
    var reciprocal: Rational? {
        // `-IntegerType.min` overflows.
        guard !isZero && numerator != .min else { return nil }
        return isNegative ?
        // Make sure `.denominator` is a positive value.
        Rational(numerator: -denominator, denominator: -numerator) :
        Rational(numerator: denominator, denominator: numerator)
    }
}

// MARK: - Functions
public extension Rational {
    /// Returns a random rational value between `0` (inclusive) and `1`,
    /// and whose denominator is less than or equal to `maxDenominator`.
    ///
    /// The distribution is not uniform. Although all denominator values
    /// in `1...maxDenominator` are equally likely, the distribution
    /// is biased towards values with smaller denominators. For example,
    /// `2/3` is more likely than `4/5` because the valid numerators
    /// for denominator `3` are `0...2` (assuming `includingOne`
    /// is false), but for denominator 5, the valid numerators are `0...4`.
    ///
    /// - Parameters:
    ///   - maxDenominator: The maximum denominator
    ///   to choose from. Default value is `100`.
    ///   - includingOne: Pass `true` to include `1`
    ///   in the range of values. Default value is `false`.
    ///
    /// - Requires: `maxDenominator > 0`
    static func random(maxDenominator: IntegerType = 100, includingOne: Bool = false) -> Rational {
        // Choose two random integers n and d such that:
        // 1) 0 <= n < (or <=) d
        // 2) 1 <= d <= `maxDenominator`
        let denominator = IntegerType.random(in: 1...maxDenominator)
        let numerator: IntegerType = includingOne ?
            .random(in: 0...denominator) :
            .random(in: 0..<denominator)
        return Rational(numerator, denominator)
    }
    
    /// Returns a lazy sequence of the digits after
    /// the radix point, ignoring trailing zeros.
    ///
    /// The returned sequence is infinite in length if
    /// this value is a repeating fraction in `radix`.
    ///
    /// - Parameter radix: The radix to use for finding the digits.
    /// Default value is `10`.
    func fractionalDigits(radix: IntegerType = 10) -> UnfoldSequence<IntegerType, IntegerType> {
        sequence(state: remainder) { remainder in
            // Ignore trailing zeros.
            guard remainder != 0 else { return nil }
            // TODO: Can we handle overflow here?
            remainder *= radix
            let result = remainder.quotientAndRemainder(dividingBy: denominator)
            remainder = result.remainder
            return result.quotient
        }
    }
    
    /// Returns this value rounded to the nearest integer
    /// using the given rounding rule.
    ///
    /// The currently supported rounding rules are:
    /// - `.toNearestOrAwayFromZero`
    /// - `.toNearestOrEven`
    /// - `.up`
    /// - `.down`
    /// - `.towardZero`
    /// - `.awayFromZero`
    ///
    /// - Parameter rule: The rule used to round this value.
    /// Default value is `.toNearestOrAwayFromZero`.
    func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> IntegerType {
        // First check if this value is an integer.
        guard denominator != 1 else { return numerator }
        let (quotient, remainder) = quotientAndRemainder
        // If this value is negative:
        // --(q - 1)---(self)-----(q)----
        //
        // If it is positive:
        // ----(q)-----(self)---(q + 1)--
        switch rule {
        case .toNearestOrAwayFromZero:
            // If the magnitude of the fractional part is
            // less than 1/2, we round towards zero.
            //
            // |r|    1
            // --- < --- <=> 2 * |r| < |d|
            // |d|    2
            //
            // Multiplication is safe from overflow errors.
            // |r| < |d| <= `IntegerType.max`
            // 2 * |r| < 2 * `IntegerType.max` < `IntegerType.Magnitude.max`
            if 2 * remainder.magnitude < denominator.magnitude {
                return rounded(.towardZero)
            }
            // Otherwise, we round away from zero.
            return rounded(.awayFromZero)
        case .toNearestOrEven:
            // If the magnitude of the fractional part is
            // 1/2, we round towards the even of the two.
            if remainder.magnitude == 1 && denominator == 2 {
                return quotient.isMultiple(of: 2) ? quotient : rounded(.awayFromZero)
            }
            // Otherwise, we round towards the nearest.
            return rounded(.toNearestOrAwayFromZero)
        case .up:
            return isNegative ? quotient : quotient + 1
        case .down:
            return isNegative ? quotient - 1 : quotient
        case .towardZero:
            return quotient
        case .awayFromZero:
            return isNegative ? quotient - 1 : quotient + 1
        @unknown default:
            fatalError("Unsupported rounding rule \(rule).")
        }
    }
}
