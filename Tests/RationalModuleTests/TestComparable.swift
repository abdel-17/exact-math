import XCTest
import RationalModule

class TestComparable: XCTestCase {
    private func testRandomPair<T>(type: Rational<T>.Type, max: T) {
        let (x, y) = pair {
            type.init(.random(in: -max...max), .random(in: 1...max))
        }
        // Validate using the naive expression.
        XCTAssertEqual(x < y, x.numerator * y.denominator < x.denominator * y.numerator)
    }
    
    func testRandomPair() {
        // Limit the values to `floor(sqrt(IntegerType.max))`
        // to avoid overflow.
        testRandomPair(type: Rational<Int64>.self, max: 3_037_000_499)
        testRandomPair(type: Rational<Int32>.self, max: 46_340)
        testRandomPair(type: Rational<Int16>.self, max: 181)
        testRandomPair(type: Rational<Int8>.self, max: 11)
    }
    
    private func testNearOverflowBoundary<T>(type: Rational<T>.Type) {
        XCTAssertTrue(type.init(.max, 3) < type.max)
        XCTAssertTrue(type.min < type.init(.min, 3))
    }
    
    func testNearOverflowBoundary() {
        testNearOverflowBoundary(type: Rational<Int64>.self)
        testNearOverflowBoundary(type: Rational<Int32>.self)
        testNearOverflowBoundary(type: Rational<Int16>.self)
        testNearOverflowBoundary(type: Rational<Int8>.self)
    }
}
