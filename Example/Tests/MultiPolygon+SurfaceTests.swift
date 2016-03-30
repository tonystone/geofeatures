//
//  MultiPolygon+SurfaceTests.swift
//  GeoFeatures2
//
//  Created by Tony Stone on 3/29/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

class MultiPolygon_SurfaceTests: XCTestCase {

    let fixed = FixedPrecision(scale: 100000)
    
    // MARK: Coordinate2D
    // MARK: FixedPrecision
    
    func testAre_Cartisian_Empty() {
        XCTAssertEqual(MultiPolygon<Coordinate2D>(precision: fixed).area(), 0.0)
    }

}
