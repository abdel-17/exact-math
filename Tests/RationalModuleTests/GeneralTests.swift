//
//  GeneralRationalTests.swift
//  
//
//  Created by Abdel on 26/07/2022.
//

import XCTest
import RationalModule

class GeneralTests: XCTestCase {
    private let supportedRoundingRules: [FloatingPointRoundingRule] = [
        .toNearestOrAwayFromZero,
        .toNearestOrEven,
        .up,
        .down,
        .towardZero,
        .awayFromZero
    ]
    
    func testRandomGenerator() {
        // Generate a random number in [0, 1).
        let x = Rational<Int>.random()
        XCTAssertFalse(x.isNegative)
        XCTAssertTrue(x.isProper)
        // Default value for `maxDenominator`.
        XCTAssertTrue(x.denominator <= 1000)
        
        // Generate a random number in [0, 1].
        let y = Rational<Int>.random(includingOne: true)
        XCTAssertTrue(y.numerator <= y.denominator)
        
        // Generate a random number in (0, 1).
        let z = Rational<Int>.random(includingZero: false)
        XCTAssertFalse(z.isZero)
    }
    
    func testFractionalDigits() {
        let x = Rational(3, 4)  // 0.75
        XCTAssertTrue(x.fractionalDigits().elementsEqual([7, 5]))
        // 3/4 = (2 ** -1) + (2 ** -2) = 0.11 (base 2)
        XCTAssertTrue(x.fractionalDigits(radix: 2).elementsEqual([1, 1]))
        
        let y = Rational(-2, 3) // -0.666....
        // -2/3 is a repeating fraction, so we check if
        // the first 1000 digits are all 6.
        XCTAssertTrue(y.fractionalDigits().prefix(1000).allSatisfy { $0 == 6 })
        // 2/3 = 2 * (3 ** -1) = 0.2 (base 3)
        XCTAssertTrue(y.fractionalDigits(radix: 3).elementsEqual(CollectionOfOne(2)))
        
        // Integers have no fractional digits (trailing zeros are ignored).
        let z: Rational<Int> = 1
        var digitsOfZ = z.fractionalDigits()
        XCTAssertNil(digitsOfZ.next())
    }
    
    func testRounding() {
        let x: Rational<Int> = 1
        for rule in supportedRoundingRules {
            // Integer round to the same value.
            XCTAssertEqual(x.rounded(rule), 1)
        }
        
        let y = Rational(4, 3)  // 1.333...
        XCTAssertEqual(supportedRoundingRules.map(y.rounded), [1, 1, 2, 1, 1, 2])
        
        let z = Rational(-1, 2)  // -0.5
        XCTAssertEqual(supportedRoundingRules.map(z.rounded), [-1, 0, 0, -1, 0, -1])
    }
}
