import XCTest
import RationalModule

class TestSignedNumeric: XCTestCase {
    func testRandomPairs() throws {
        for _ in 0..<100_000 {
            let (x, y) = pair {
                Rational<Int>.random(maxDenominator: 100_000, includingOne: true)
            }
            // Validate using the naive expression.
            let product = Rational(x.numerator * y.numerator,
                                   x.denominator * y.denominator)
            XCTAssertEqual(x * y, product)
            // Assert that -x is the additive inverse of x.
            XCTAssertEqual(x + -x, .zero)
            // Assert that the magnitude of x is non-negative.
            XCTAssertFalse(x.magnitude.isNegative)
        }
    }
    
    func testOverflowOperators() throws {
        XCTAssertThrowsError(try Rational<Int64>.max &* 2)
        XCTAssertThrowsError(try Rational<Int64>.min &* 2)
        XCTAssertThrowsError(try Rational<Int64>.min &* -1)
        
        XCTAssertThrowsError(try Rational<Int32>.max &* 2)
        XCTAssertThrowsError(try Rational<Int32>.min &* 2)
        XCTAssertThrowsError(try Rational<Int32>.min &* -1)
        
        XCTAssertThrowsError(try Rational<Int16>.max &* 2)
        XCTAssertThrowsError(try Rational<Int16>.min &* 2)
        XCTAssertThrowsError(try Rational<Int16>.min &* -1)
        
        XCTAssertThrowsError(try Rational<Int8>.max &* 2)
        XCTAssertThrowsError(try Rational<Int8>.min &* 2)
        XCTAssertThrowsError(try Rational<Int8>.min &* -1)
    }
}
