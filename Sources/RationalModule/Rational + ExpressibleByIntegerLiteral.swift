extension Rational: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = IntegerType.IntegerLiteralType
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(IntegerType(integerLiteral: value))
    }
}
