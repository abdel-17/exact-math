import XCTest
import RationalModule

class TestStringConversion: XCTestCase {
    func testExamples() {
        let x = Rational<Int>(10, 3)
        XCTAssertEqual(String(reflecting: x), "Rational<Int>(10, 3)")
        // Radix defaults to 10.
        XCTAssertEqual(String(x), "10/3")
        XCTAssertEqual(x, Rational("10/3"))
        
        let y = Rational<Int>(0b1000101)
        XCTAssertEqual(String(y, radix: 2), "1000101")
        XCTAssertEqual(y, Rational("1000101", radix: 2))
        
        let z = Rational<Int>(0x1a4)
        // Uppercase defaults to `false`.
        let lowercase = String(z, radix: 16)
        XCTAssertEqual(lowercase, "1a4")
        XCTAssertEqual(z, Rational(lowercase, radix: 16))
        // Parsing is case insensitive
        let uppercase = String(z, radix: 16, uppercase: true)
        XCTAssertEqual(uppercase, "1A4")
        XCTAssertEqual(z, Rational(uppercase, radix: 16))
    }
    
    func testInvalidPatterns() {
        // "8" out of bounds for radix 8.
        XCTAssertNil(Rational<Int>("800", radix: 8))
        XCTAssertEqual(Rational<Int>("700", radix: 8), Rational(0o700))
        
        // Whitespace.
        XCTAssertNil(Rational<Int>("2 / 3"))
        XCTAssertEqual(Rational<Int>("2/3"), Rational(2, 3))
        
        // Negative sign in the wrong place.
        XCTAssertNil(Rational<Int>("5/-2"))
        XCTAssertEqual(Rational<Int>("-5/2"), Rational(-5, 2))
        
        // Division by zero.
        XCTAssertNil(Rational<Int>("1/0"))
        
        // 128 out of bounds for Int8.
        XCTAssertNil(Rational<Int8>("128/2"))
        XCTAssertEqual(Rational<Int16>("128/2"), 64)
        
        // Does not match 1 rational pattern.
        XCTAssertNil(Rational<Int>("+1/3-2/3"))
        XCTAssertEqual(Rational<Int>("+1/3"), Rational(1, 3))
        XCTAssertEqual(Rational<Int>("-2/3"), Rational(-2, 3))
    }
}
