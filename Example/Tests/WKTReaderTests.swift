//
//  WKTReaderTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 2/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import GeoFeatures2

class WKTReaderTests: XCTestCase {


    func testRead_Point() {
        XCTAssert(WKTReader<Point>.read("POINT(1,1,0)") != nil)
    }
}
