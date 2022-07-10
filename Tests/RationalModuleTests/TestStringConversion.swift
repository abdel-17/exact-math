import XCTest
@testable import RationalModule

class TestStringConversion: XCTestCase {
    func testExample() throws {
        // "9" out of bounds for radix 8.
        XCTAssertNil(Rational<UInt>("900", radix: 8))
        XCTAssertNotNil(Rational<UInt>("700", radix: 8))
        // Whitespace.
        XCTAssertNil(Rational<UInt>(" 24", radix: 10))
        XCTAssertNotNil(Rational<UInt>("24", radix: 10))
        XCTAssertNil(Rational<UInt>("2 / 3", radix: 10))
        XCTAssertNotNil(Rational<UInt>("2/3", radix: 10))
        // Negative sign in the wrong place.
        XCTAssertNil(Rational<UInt>("5/-2", radix: 10))
        XCTAssertNotNil(Rational<UInt>("-5/2", radix: 10))
        // Division by zero.
        XCTAssertNil(Rational<UInt>("1/0", radix: 10))
        // 256 out of bounds for UInt8.
        XCTAssertNil(Rational<UInt8>("256/2", radix: 10))
        XCTAssertNotNil(Rational<UInt16>("256/2", radix: 10))
        // Match only one rational value.
        XCTAssertNil(Rational<UInt>("+1/3-2/3"))
        XCTAssertNotNil(Rational<UInt>("+1/3"))
        XCTAssertNotNil(Rational<UInt>("-2/3"))
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
