import XCTest
import RationalModule

class TestComparable: XCTestCase {
    private func testRandomPair<T>(type: Rational<T>.Type, max: T) {
        let (x, y) = pair {
            type.init(.random(in: -max...max), .random(in: 1...max))
        }
        // Validate using the naive expression.
        let inIncreasingOrder = x.numerator * y.denominator < x.denominator * y.numerator
        XCTAssertEqual(x < y, inIncreasingOrder)
    }
    
    func testRandomPair() {
        // Limit the values to sqrt(.max) to avoid overflow.
        testRandomPair(type: Rational<Int64>.self, max: 3_037_000_499)
        testRandomPair(type: Rational<Int32>.self, max: 46_340)
        testRandomPair(type: Rational<Int16>.self, max: 181)
        testRandomPair(type: Rational<Int8>.self, max: 11)
    }
    
    private func testNearOverflowBoundary<T>(type: Rational<T>.Type) {
        XCTAssertTrue(type.max / 2 < type.max)
        XCTAssertTrue(type.min < type.min / 2)
    }
    
    func testNearOverflowBoundary() {
        testNearOverflowBoundary(type: Rational<Int64>.self)
        testNearOverflowBoundary(type: Rational<Int32>.self)
        testNearOverflowBoundary(type: Rational<Int16>.self)
        testNearOverflowBoundary(type: Rational<Int8>.self)
    }
}
