//
//  MultiPolygon+SurfaceTests.swift
//  GeoFeatures2
//
//  Created by Tony Stone on 3/29/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

// MARK: - Coordinate2D, FixedPrecision, Cartesian -

class MultiPolygon_Surface_Coordinate2D_FixedPrecision_Cartesian_Tests: XCTestCase {

    let precision = FixedPrecision(scale: 100000)
    let crs       = Cartesian()
    
    func testArea_Empty() {
        XCTAssertEqual(MultiPolygon<Coordinate2D>(precision: precision, coordinateReferenceSystem: crs).area(), 0.0)
    }

}
