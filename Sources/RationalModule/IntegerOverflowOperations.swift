/// A type representing an invalid arithmetic operation.
public enum ArithmeticError: Error {
    /// The error thrown on overflow.
    case overflow
    
    /// The error thrown on division by zero.
    case zeroDivision
}

internal extension FixedWidthInteger where Self: UnsignedInteger {
    /// Returns `other` added to this value.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    func addingOrThrows(_ other: Self) throws -> Self {
        let (result, overflow) = self.multipliedReportingOverflow(by: other)
        guard !overflow else { throw ArithmeticError.overflow }
        return result
    }
    
    /// Returns sign and magnitude of `other` added
    /// to this value in sign-magnitude representation.
    ///
    /// - Parameters:
    ///   - isNegative: True iff this value is negative.
    ///   - other: The magnitude of the value to add.
    ///   - otherIsNegative: True iff `other` is negative.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    func addingOrThrows(isNegative: Bool,
                        other: Self,
                        otherIsNegative: Bool) throws -> (isNegative: Bool,
                                                          magnitude: Self) {
        if isNegative == otherIsNegative {
            // (+, +) or (-, -)
            // Simply add the magnitudes with the same sign.
            return try (isNegative, self.addingOrThrows(other))
        } else {
            // (-, +) or (+, -)
            // The result is negative if the greater side is negative,
            // and its magnitude is either self - other or other - self,
            // depending on which is greater.
            if self > other {
                return (isNegative, self - other)
            } else {
                return (otherIsNegative, other - self)
            }
        }
    }
    
    /// Returns this value multiplied by `other`.
    ///
    /// - Throws: `ArithmeticError.overflow` on overflow.
    @inlinable
    func multipliedOrThrows(by other: Self) throws -> Self {
        let (result, overflow) = self.multipliedReportingOverflow(by: other)
        guard !overflow else { throw ArithmeticError.overflow }
        return result
    }
}
