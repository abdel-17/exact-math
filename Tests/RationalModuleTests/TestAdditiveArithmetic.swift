import XCTest
import RationalModule

class TestAdditiveArithmetic: XCTestCase {
    // Test with a random sample of 10_000 rational pairs.
    private let sample = Rational<Int>.randomPairSample(count: 10_000)
    
    func testAddition() throws {
        for (lhs, rhs) in sample {
            // Make sure addition is correct by using the naive expressions.
            let sum = Rational(lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator,
                               lhs.denominator * rhs.denominator)
            XCTAssertEqual(lhs + rhs, sum)
            XCTAssertEqual(try lhs &+ rhs, sum)
        }
    }
    
    func testSubtraction() throws {
        for (lhs, rhs) in sample {
            // Make sure addition is correct by using the naive expressions.
            let difference = Rational(lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator,
                                      lhs.denominator * rhs.denominator)
            XCTAssertEqual(lhs - rhs, difference)
            XCTAssertEqual(try lhs &- rhs, difference)
        }
    }
}
