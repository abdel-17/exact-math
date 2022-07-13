import RealModule

/// A type representing an arithmetic operation.
public enum ArithmeticOperation {
    case addition
    case subtraction
    case multiplication
    case division
}

/// A type representing an invalid arithmetic operation.
public struct OverflowError<T : AlgebraicField>: Error {
    /// The operands the operation is performed on.
    let operands: (T, T)
    
    /// The failed operation.
    let operation: ArithmeticOperation
}

/// Returns the result of adding`rhs` to `lhs`,
/// returning `nil` on overflow.
internal func addNilOnOverflow<T : FixedWidthInteger>(_ lhs: T, _ rhs: T) -> T? {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    guard !overflow else { return nil }
    return result
}
    
/// Returns the result of subtracting`rhs` from `lhs`,
/// returning `nil` on overflow.
internal func subtractNilOnOverflow<T : FixedWidthInteger>(_ lhs: T, _ rhs: T) -> T? {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    guard !overflow else { return nil }
    return result
}

/// Returns the result of multiplying`lhs` by `rhs`,
/// returning `nil` on overflow.
internal func multiplyNilOnOverflow<T : FixedWidthInteger>(_ lhs: T, _ rhs: T) -> T? {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    guard !overflow else { return nil }
    return result
}
