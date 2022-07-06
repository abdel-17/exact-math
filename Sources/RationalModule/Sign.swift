/// The sign of a non-zero number.
public enum Sign: CaseIterable {
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
