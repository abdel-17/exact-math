import XCTest
import RationalModule

class TestSignedNumeric: XCTestCase {
    private func testRandomPair<T>(type: Rational<T>.Type, max: T) {
        let (x, y) = pair {
            type.init(.random(in: -max...max), .random(in: 1...max))
        }
        // Validate using the naive expression.
        let product = Rational(x.numerator * y.numerator, x.denominator * y.denominator)
        XCTAssertEqual(x * y, product)
        // Assert that -x is the additive inverse of x.
        XCTAssertEqual(x + -x, .zero)
        // Assert that the magnitude of x is non-negative.
        XCTAssertFalse(x.magnitude.isNegative)
    }
    
    func testRandomPair() {
        // Limit the values to sqrt(.max) to avoid overflow.
        testRandomPair(type: Rational<Int64>.self, max: 3_037_000_499)
        testRandomPair(type: Rational<Int32>.self, max: 46_340)
        testRandomPair(type: Rational<Int16>.self, max: 181)
        testRandomPair(type: Rational<Int8>.self, max: 11)
    }
    
    private func testOverflowOperators<T>(for type: Rational<T>.Type) {
        let greaterThanOne = type.init(integral: 1,
                                       fractional: .random(includingZero: false))
        XCTAssertThrowsError(try type.max &* greaterThanOne)
        XCTAssertThrowsError(try type.min &* greaterThanOne)
        XCTAssertThrowsError(try type.min &* -1)
    }
    
    func testOverflowOperators() {
        testOverflowOperators(for: Rational<Int64>.self)
        testOverflowOperators(for: Rational<Int32>.self)
        testOverflowOperators(for: Rational<Int16>.self)
        testOverflowOperators(for: Rational<Int8>.self)
    }
}
