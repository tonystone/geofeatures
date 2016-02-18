//
//  WKTReaderTests.swift
//  GeoFeatures
//
//  Created by Tony Stone on 2/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import GeoFeatures2

class WKTReaderTests: XCTestCase {


    func testRead_Point() {
        
        do {
            let _ = try WKTReader.read("POINT(1,1,0)")
            
//            XCTAssertEqual(point == Point(coordinate: (1.0, 1.0,0.0)), true)
        } catch {
            XCTFail("Parsing failed.")
        }
    }
}
