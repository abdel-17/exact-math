import RealModule

/// A rational number with a sign-magnitude representation.
///
/// All values of this type are reduced to their simplest form,
/// i.e. the numerator and denominator are coprime.
public struct Rational<IntegerType : UnsignedInteger & FixedWidthInteger> {
    /// The sign of a rational number.
    public enum Sign {
        case plus, minus
        
        /// Returns the sign opposite to `operand`.
        @inlinable
        public static prefix func - (operand: Sign) -> Sign {
            switch operand {
            case .plus:
                return .minus
            case .minus:
                return .plus
            }
        }
        
        /// Replaces this value with the opposite sign.
        @inlinable
        public mutating func negate() {
            self = -self
        }
    }
    
    /// The sign of this value.
    public let sign: Sign
    
    /// The reduced numerator of this value.
    public let numerator: IntegerType
    
    /// The reduced denominator of this value.
    public let denominator: IntegerType
    
    /// Creates a rational value.
    ///
    /// - Parameters:
    ///   - sign: The sign of the value.
    ///   - numerator: The reduced numerator of the value.
    ///   - denominator: The reduced denominator of the value.
    @inlinable
    internal init(sign: Sign = .plus, numerator: IntegerType, denominator: IntegerType) {
        self.sign = sign
        self.numerator = numerator
        self.denominator = denominator
    }
    
    /// Creates a rational value, reducing the given fraction.
    @inlinable
    public init(_ numerator: IntegerType, _ denominator: IntegerType) {
        // Initialize with the reduced fraction.
        let g = gcd(numerator, denominator)
        self.init(numerator: numerator / g,
                  denominator: denominator / g)
    }
}
