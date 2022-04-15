//
//  MathTest.swift
//  MathTest
//
//  Created by Phil Weckenmann on 4/15/22.
//

import XCTest
@testable import YTree

class MathTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInRange() throws {
        XCTAssertEqual(0.5.inRange(max: 1), 0.5)
        XCTAssertEqual(2.inRange(max: 1), 1)
        XCTAssertEqual((-1).inRange(max: 1), 0)
        XCTAssertEqual((-0.5).inRange(min: -0.4, max: 1), -0.4)
    }
    
    func testDegreeInit() throws {
        XCTAssertEqual(Degrees(90).degrees, 90)
        XCTAssertEqual(Degrees(360).degrees, 0)
        XCTAssertEqual(Degrees(-30).degrees, 330)
    }
}
