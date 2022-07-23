import XCTest
import RationalModule

func pair<T>(generator: () -> T) -> (T, T) {
    (generator(), generator())
}

class TestAdditiveArithmetic: XCTestCase {
    private func testRandomPair<T>(type: Rational<T>.Type, max: T) {
        let (x, y) = pair {
            type.init(.random(in: -max...max), .random(in: 1...max))
        }
        // Validate using the naive expressions.
        let a = x.numerator * y.denominator
        let b = x.denominator * y.numerator
        let d = x.denominator * y.denominator
        let sum = Rational(a + b, d)
        XCTAssertEqual(x + y, sum)
        let difference = Rational(a - b, d)
        XCTAssertEqual(x - y, difference)
    }
    
    func testRandomPair() {
        // Limit the values to sqrt(.max) to avoid overflow.
        testRandomPair(type: Rational<Int64>.self, max: 3_037_000_499)
        testRandomPair(type: Rational<Int32>.self, max: 46_340)
        testRandomPair(type: Rational<Int16>.self, max: 181)
        testRandomPair(type: Rational<Int8>.self, max: 11)
    }
    
    private func testOverflowOperators<T>(for type: Rational<T>.Type) {
        let nonZero = type.random(includingZero: false)
        XCTAssertThrowsError(try type.max &+ nonZero)
        XCTAssertThrowsError(try type.min &- nonZero)
    }
    
    func testOverflowOperators() {
        testOverflowOperators(for: Rational<Int64>.self)
        testOverflowOperators(for: Rational<Int32>.self)
        testOverflowOperators(for: Rational<Int16>.self)
        testOverflowOperators(for: Rational<Int8>.self)
    }
}
