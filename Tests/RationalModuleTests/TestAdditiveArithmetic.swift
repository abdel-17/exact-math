import XCTest
import RationalModule

func pair<T>(generator: () -> T) -> (T, T) {
    (generator(), generator())
}

class TestAdditiveArithmetic: XCTestCase {
    func testRandomPairs() throws {
        for _ in 0..<100_000 {
            let (x, y) = pair {
                Rational<Int>.random(maxDenominator: 100_000, includingOne: true)
            }
            // Validate using the naive expressions.
            let sum = Rational(x.numerator * y.denominator + x.denominator * y.numerator,
                               x.denominator * y.denominator)
            XCTAssertEqual(x + y, sum)
            let difference = Rational(x.numerator * y.denominator - x.denominator * y.numerator,
                                      x.denominator * y.denominator)
            XCTAssertEqual(x - y, difference)
        }
    }
    
    func testOverflowOperators() throws {
        XCTAssertThrowsError(try Rational<Int64>.max &+ 1)
        XCTAssertThrowsError(try Rational<Int64>.min &- 1)

        XCTAssertThrowsError(try Rational<Int32>.max &+ 1)
        XCTAssertThrowsError(try Rational<Int32>.min &- 1)
        
        XCTAssertThrowsError(try Rational<Int16>.max &+ 1)
        XCTAssertThrowsError(try Rational<Int16>.min &- 1)
        
        XCTAssertThrowsError(try Rational<Int8>.max &+ 1)
        XCTAssertThrowsError(try Rational<Int8>.min &- 1)
    }
}
