//
//  ColorTest.swift
//  ColorTest
//
//  Created by Phil Weckenmann on 3/30/22.
//

import XCTest
@testable import CARDS

class ColorTest: XCTestCase {
    
    let convertables = [
        (rgb: RGB(r: 1, g: 0, b: 0), hslv: HSLV(h: 0, s: 1, l: 0.5)),
        (rgb: RGB(r: 1, g: 1, b: 0), hslv: HSLV(h: 60, s: 1, l: 0.5)),
        (rgb: RGB(r: 1, g: 1, b: 1), hslv: HSLV(h: 180, s: 0, l: 1)),
        
        (rgb: RGB(r: 1, g: 1, b: 0.2), hslv: HSLV(h: 60, s: 1, l: 0.6)),

    ]
    let convertables2 = [
        (hsl: HSLV(h: 30, s: 1, l: 0.5), s: Float(1), v: Float(1)),
        (hsl: HSLV(h: 30, s: 0.8, l: 0.5), s: Float(0.89), v: Float(0.9)),
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testHSL_to_HSV_Conversion() throws {
        for color in convertables2 {
            XCTAssertEqual(color.hsl.s_v, color.s, accuracy: 0.01)
            XCTAssertEqual(color.hsl.v, color.v, accuracy: 0.01)
        }
    }
    
    func testRGB_to_HSLV_Conversion() throws {
        for color in convertables {
            XCTAssertEqual(color.rgb.toHSLV(), color.hslv)
        }
    }
    
    func testHSLV_to_RGB_Conversion() throws {
        for color in convertables {
            XCTAssertEqual(color.hslv.toRGB(), color.rgb)
        }
    }
    
    func testSettingRGB() throws {
        
    }
    func testGettingRGB() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
