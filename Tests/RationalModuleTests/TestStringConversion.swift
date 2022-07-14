import XCTest
@testable import RationalModule

class TestStringConversion: XCTestCase {
    func testExample() throws {
        // "9" out of bounds for radix 8.
        XCTAssertNil(Rational<Int>("900", radix: 8))
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
        XCTAssertEqual(Rational<Int>("A8/a8", radix: 16), 1)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
