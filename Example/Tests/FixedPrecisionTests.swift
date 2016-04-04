//
//  FixedPrecisionTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 2/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

class FixedPrecisionTests: XCTestCase {

    let precision  = FixedPrecision(scale: 10)
    
    func testConvert_Scale10_Lower() {
        XCTAssertEqual(precision.convert(1.01), 1.0)
    }
    
    func testConvert_Scale10_Middle() {
        XCTAssertEqual(precision.convert(1.05), 1.1)
    }
    
    func testConvert_Scale10_Upper() {
        XCTAssertEqual(precision.convert(1.09), 1.1)
    }
    
    func testConvert_Scale10_Lower2() {
        XCTAssertEqual(precision.convert(1.0111), 1.0)
    }
    
    func testConvert_Scale10_Middle2() {
        XCTAssertEqual(precision.convert(1.0555), 1.1)
    }
    
    func testConvert_Scale10_Upper2() {
        XCTAssertEqual(precision.convert(1.0999), 1.1)
    }
}
