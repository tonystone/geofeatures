//
//  LengthTests.swift
//  GeoFeatures2
//
//  Created by Tony Stone on 2/16/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

class LengthTests: XCTestCase {


    func testLength_Cartisian_Test1() {
        XCTAssertEqual(LineString(coordinates: [(0,0),(1,1)]).length(), 1.4142135623730951)
    }

    func testLength_Cartisian_Test2() {
        XCTAssertEqual(LineString(coordinates: [(0,0),(0,2)]).length(), 2.0)
    }

}
