import XCTest
import RationalModule

class TestInitializers: XCTestCase {
    func testFractionInitializer() {
        // Canonical form.
        let x = Rational(1, 3)
        XCTAssertEqual(x.numerator, 1)
        XCTAssertEqual(x.denominator, 3)
        
        // Denominator is negative.
        let y = Rational(1, -2)
        XCTAssertEqual(y.numerator, -1)
        XCTAssertEqual(y.denominator, 2)
        
        // Fraction is not reduced.
        let z = Rational(4, 6)
        XCTAssertEqual(z.numerator, 2)
        XCTAssertEqual(z.denominator, 3)
        
        XCTAssertEqual(Rational<Int>(.min, .min), .one)
        XCTAssertEqual(Rational<Int>(0, .min), .zero)
    }
    
    func testMixedInitializer() {
        let fourThird = Rational(4, 3)
        let x = Rational(integral: 1, fractional: Rational(1, 3))
        XCTAssertEqual(x, fourThird)
        
        let y = Rational(integral: 2, fractional: Rational(-2, 3))
        XCTAssertEqual(y, fourThird)
        
        let z = Rational(integral: -1, fractional: Rational.max)
        XCTAssertEqual(z, Rational(Int.max - 1))
    }
    
    func testBinaryIntegerInitializer() {
        let x = Rational(2, 3)      // 0.666...
        XCTAssertEqual(Int(x), 0)
        XCTAssertNil(Int(exactly: x))
        
        let y = Rational(-5, 2)     // -2.5
        XCTAssertEqual(Int(y), -2)
        XCTAssertNil(Int(exactly: y))
        
        let z: Rational<Int> = 1
        XCTAssertEqual(Int(z), 1)
        XCTAssertEqual(Int(exactly: z), 1)
        
        XCTAssertNil(Int16(exactly: Rational<Int>.max))
    }
}
