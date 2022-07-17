import XCTest
import RationalModule

class TestStringConversion: XCTestCase {
    func testFromStringExamples() throws {
        // "8" out of bounds for radix 8.
        XCTAssertNil(Rational<Int>("800", radix: 8))
        XCTAssertEqual(Rational<Int>("700", radix: 8), Rational(7 << (3 * 2)))
        // Whitespace.
        XCTAssertNil(Rational<Int>(" 24"))
        XCTAssertEqual(Rational<Int>("24"), 24)
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
        // Match only one rational value.
        XCTAssertNil(Rational<Int>("+1/3-2/3"))
        // Letters are acceptable for radix > 10.
        XCTAssertEqual(Rational<Int>("-f0008", radix: 16), -Rational(8 + 15 << (4 * 4)))
        // Parsing is case insensitive.
        XCTAssertEqual(Rational<Int>("A8/a8", radix: 16), 1)
    }
    
    func testToStringExamples() throws {
        // Test decimal.
        let x: Rational<Int> = 4
        XCTAssertEqual(String(x), "4")
        XCTAssertEqual(String(x, uppercase: true), "4")
        XCTAssertEqual(String(reflecting: x), "Rational<Int>(4, 1)")
        // Test binary.
        let y = Rational(0b11, 0b10)
        XCTAssertEqual(String(y, radix: 2), "11/10")
        XCTAssertEqual(String(y, radix: 2, uppercase: true), "11/10")
        XCTAssertEqual(String(reflecting: y), "Rational<Int>(3, 2)")
        // Test hexadecimal.
        let z: Rational<Int> = 0x1a4
        XCTAssertEqual(String(z, radix: 16), "1a4")
        XCTAssertEqual(String(z, radix: 16, uppercase: true), "1A4")
        XCTAssertEqual(String(reflecting: z), "Rational<Int>(420, 1)")
    }
    
    func testRandomSample() throws {
        for x in Rational<Int>.randomSample(count: 10_000) {
            for radix in 2...36 {
                let lowercaseDescription = String(x, radix: radix)
                XCTAssertEqual(x, Rational(lowercaseDescription, radix: radix))
                let uppercaseDescription = String(x, radix: radix, uppercase: true)
                XCTAssertEqual(x, Rational(uppercaseDescription, radix: radix))
            }
        }
    }
}
