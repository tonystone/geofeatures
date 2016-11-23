//
//  CoordinateReferenceSystemTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 11/9/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures

fileprivate struct DummyCoordinateReferenceSystem: CoordinateSystem, Equatable, Hashable {
    public var hashValue: Int { get { return String(reflecting: self).hashValue } }
}

class CoordinateReferenceSystemTests: XCTestCase {

    func testEqual_True() {
        XCTAssertTrue(Cartesian() == Cartesian())
    }

    func testEqual_False() {
        XCTAssertFalse(Cartesian() == DummyCoordinateReferenceSystem())
    }
}
