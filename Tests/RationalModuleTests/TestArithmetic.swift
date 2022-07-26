import XCTest
import RationalModule

func pair<T>(generator: () -> T) -> (T, T) {
    (generator(), generator())
}

class TestArithmetic: XCTestCase {
    private func testRandomPair<T>(type: Rational<T>.Type, max: T) {
        let (x, y) = pair {
            type.init(.random(in: -max...max), .random(in: 1...max))
        }
        // Validate using the naive expressions.
        // AdditiveArithmetic:
        let a = x.numerator * y.denominator
        let b = x.denominator * y.numerator
        let d = x.denominator * y.denominator
        XCTAssertEqual(x + y, Rational(a + b, d))
        XCTAssertEqual(x - y, Rational(a - b, d))
        
        // SignedNumeric:
        let product = Rational(x.numerator * y.numerator, x.denominator * y.denominator)
        XCTAssertEqual(x * y, product)
        // Assert that -x is the additive inverse of x.
        XCTAssertEqual(x + -x, .zero)
        
        // AlgebraicField:
        // Make sure the divisor is non-zero.
        let z = type.init(.random(in: 1...max), .random(in: 1...max))
        let ratio = Rational(x.numerator * z.denominator, x.denominator * z.numerator)
        XCTAssertEqual(x / z, ratio)
        // Assert that `z.reciprocal` is the multiplicative inverse of y.
        XCTAssertEqual(z * z.reciprocal!, .one)
    }
    
    func testRandomPair() {
        // Limit the values to `floor(sqrt(IntegerType.max))`
        // to avoid overflow.
        testRandomPair(type: Rational<Int64>.self, max: 3_037_000_499)
        testRandomPair(type: Rational<Int32>.self, max: 46_340)
        testRandomPair(type: Rational<Int16>.self, max: 181)
        testRandomPair(type: Rational<Int8>.self, max: 11)
    }
    
    private func testOverflowOperators<T>(type: Rational<T>.Type) {
        // AdditiveArithmetic:
        let positive = type.random(includingZero: false)
        XCTAssertThrowsError(try type.max &+ positive)
        XCTAssertThrowsError(try type.min &- positive)
        
        // SignedNumeric:
        let greaterThanOne = type.init(integral: 1, fractional: positive)
        XCTAssertThrowsError(try type.max &* greaterThanOne)
        XCTAssertThrowsError(try type.min &* greaterThanOne)
        XCTAssertThrowsError(try type.min &* -1)
        
        // AlgebraicField:
        XCTAssertThrowsError(try type.one &/ 0)
        // Test the edge cases with `.min`.
        // If x is a positive odd value, both
        // `.min / -x` and `x / .min` overflow.
        let odd = type.init(2 * .random(in: 0...(T.max / 2)) + 1)
        XCTAssertThrowsError(try odd &/ type.min)
        XCTAssertThrowsError(try type.min &/ -odd)
        XCTAssertNoThrow(try type.min &/ odd)
        // `odd >= 1` <=> `odd - 1 >= 0`.
        // Make sure `even` is non-zero.
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
