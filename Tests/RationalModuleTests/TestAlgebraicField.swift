import XCTest
import RationalModule

func safePair<T>(generator: () -> Rational<T>) -> (Rational<T>, Rational<T>) {
    // Make sure the divisor is non-zero.
    let first = generator()
    var second = generator()
    while second.isZero {
        second = generator()
    }
    return (first, second)
            
}

class TestAlgebraicField: XCTestCase {
    private func testRandomPair<T>(type: Rational<T>.Type, max: T) {
        let (x, y) = safePair {
            type.init(.random(in: -max...max), .random(in: 1...max))
        }
        // Validate using the naive expression.
        let ratio = Rational(x.numerator * y.denominator, x.denominator * y.numerator)
        XCTAssertEqual(x / y, ratio)
        // Assert that `y.reciprocal` is the multiplicative inverse of y.
        // We can safely force unwrap because y is non-zero.
        XCTAssertEqual(y * y.reciprocal!, .one)
    }
    
    func testRandomPair() {
        // Limit the values to sqrt(.max) to avoid overflow.
        testRandomPair(type: Rational<Int64>.self, max: 3_037_000_499)
        testRandomPair(type: Rational<Int32>.self, max: 46_340)
        testRandomPair(type: Rational<Int16>.self, max: 181)
        testRandomPair(type: Rational<Int8>.self, max: 11)
    }
    
    private func testOverflowOperators<T>(type: Rational<T>.Type) {
        // Test division by zero.
        XCTAssertThrowsError(try type.one &/ 0)
        // Test the edge cases with `.min`.
        // If x is a positive odd value, both
        // `.min / -x` and `x / .min` overflow.
        let odd = type.init(2 * .random(in: 0...(T.max / 2)) + 1)
        XCTAssertThrowsError(try odd &/ type.min)
        XCTAssertThrowsError(try type.min &/ -odd)
        XCTAssertNoThrow(try type.min &/ odd)
        // Make sure even is non-zero because we divide by it.
        let even = max(odd - 1, 2)
        XCTAssertNoThrow(try even &/ type.min)
        XCTAssertNoThrow(try type.min &/ -even)
        XCTAssertNoThrow(try type.min &/ even)
    }
    
    func testOverflowOperators() {
        testOverflowOperators(type: Rational<Int64>.self)
        testOverflowOperators(type: Rational<Int32>.self)
        testOverflowOperators(type: Rational<Int16>.self)
        testOverflowOperators(type: Rational<Int8>.self)
    }
}
