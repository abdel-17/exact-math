import XCTest
import RationalModule

private func safePair<T>(generator: () -> Rational<T>) -> (Rational<T>, Rational<T>) {
    let dividend = generator()
    var divisor: Rational<T>
    repeat {
        divisor = generator()
    }
    while divisor.isZero
    return (dividend, divisor)
}

class TestAlgebraicField: XCTestCase {
    func testRandomPairs() throws {
        for _ in 0..<100_000 {
            let (x, y) = safePair {
                Rational<Int>.random(maxDenominator: 100_000, includingOne: true)
            }
            // Validate using the naive expression.
            let ratio = Rational(x.numerator * y.denominator,
                                 x.denominator * y.numerator)
            XCTAssertEqual(x / y, ratio)
            // Assert that `y.reciprocal` is the multiplicative inverse of y.
            // We can force unwrap because y is non-zero.
            XCTAssertEqual(y * y.reciprocal!, .one)
        }
    }
    
    func testOverflowOperators() throws {
        XCTAssertThrowsError(try Rational<Int64>.random() &/ 0)
        XCTAssertThrowsError(try 1 &/ Rational<Int64>.min)
        XCTAssertThrowsError(try Rational<Int64>.min &/ -1)
        
        XCTAssertThrowsError(try Rational<Int32>.random() &/ 0)
        XCTAssertThrowsError(try 1 &/ Rational<Int32>.min)
        XCTAssertThrowsError(try Rational<Int32>.min &/ -1)
        
        XCTAssertThrowsError(try Rational<Int16>.random() &/ 0)
        XCTAssertThrowsError(try 1 &/ Rational<Int16>.min)
        XCTAssertThrowsError(try Rational<Int16>.min &/ -1)
        
        XCTAssertThrowsError(try Rational<Int8>.random() &/ 0)
        XCTAssertThrowsError(try 1 &/ Rational<Int8>.min)
        XCTAssertThrowsError(try Rational<Int8>.min &/ -1)
    }
}
