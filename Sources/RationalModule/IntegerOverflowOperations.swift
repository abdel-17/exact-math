import RealModule

/// A type representing an error in an arithmetic operation.
public enum ArithmeticError: Error {
    case overflow
    case divisionByZero
}

/// Returns the result of adding`rhs` to `lhs`,
/// throwing an error on overflow.
internal func addThrowingOnOverflow<T : FixedWidthInteger>(_ lhs: T, _ rhs: T) throws -> T {
    let (result, overflow) = lhs.addingReportingOverflow(rhs)
    guard !overflow else { throw ArithmeticError.overflow }
    return result
}
    
/// Returns the result of subtracting`rhs` from `lhs`,
/// returning `nil` on overflow.
internal func subtractThrowingOnOverflow<T : FixedWidthInteger>(_ lhs: T, _ rhs: T) throws -> T {
    let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
    guard !overflow else { throw ArithmeticError.overflow }
    return result
}

/// Returns the result of multiplying`lhs` by `rhs`,
/// returning `nil` on overflow.
internal func multiplyThrowingOnOverflow<T : FixedWidthInteger>(_ lhs: T,  _ rhs: T) throws -> T {
    let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
    guard !overflow else { throw ArithmeticError.overflow }
    return result
}
