/*
 *   GFGeometryTests.swift
 *
 *   Copyright 2016 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 04/4/2015.
 */
import XCTest
import GeoFeatures

class GFGeometryTests: XCTestCase {
    
    // MARK: Conversion required
    
    func testInit_WKT_NoThrow () {
        XCTAssertNotNil(try GFGeometry(wkt: "POLYGON((0 0,0 7,4 2,2 0,0 0))"))
    }
    
    func testInit_WKT_Throw () {
        XCTAssertThrowsError(try GFGeometry(wkt: "POLYGON INVALID"))
    }
    
    func testInit_GeoJSON_NoThrow () throws {
        XCTAssertNotNil(try GFGeometry(geoJSONGeometry: ["type" : "Point", "coordinates" : [103.0, 2.0]]))
    }
    
    func testInit_GeoJSON_Throw () {
        XCTAssertThrowsError(try GFGeometry(geoJSONGeometry: ["type" : "Invalid", "invalid" : [103.0, 2.0]]))
    }
    
    func testArea () {
        XCTAssertEqual(try GFGeometry(wkt: "POLYGON((0 0,0 7,4 2,2 0,0 0))").area(), 16.0)
    }
    
    func testArea_Throw () {
        XCTAssertTrue(true /* NOTE: Currently there are no cases that Area throws.  It is marked with try to future proof it as boost evolves. */)
    }
    
    func testLength () {
        XCTAssertEqual(try GFGeometry(wkt: "LINESTRING(0 0,1 1)").length(), 1.4142135623730951)
    }
    
    func testLength_Throw () {
        XCTAssertTrue(true /* NOTE: Currently there are no cases that length throws.  It is marked with try to future proof it as boost evolves. */)
    }
    
    func testPerimeter () {
        XCTAssertEqual(try GFGeometry(wkt: "POLYGON((0 0,0 4,4 4,4 0,0 0),(1 1,2 1,2 2,1 2,1 1))").perimeter(), 20)
    }
    
    func testCentroid () throws {
        let centroid = try GFGeometry(wkt: "POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))").centroid()
        
        XCTAssertEqual(centroid.toWKTString(), "POINT(4.04663 1.6349)")
    }
    
    func testCentroid_Throws ()  {
        XCTAssertThrowsError(try GFLineString().centroid())
    }
    
    func testBoundingBox () throws {
        let boundingBox = try GFGeometry(wkt: "POLYGON((0 1,0 9,7 9,7 1,0 1))").boundingBox()
        
        XCTAssertEqual(boundingBox.toWKTString(), "POLYGON((0 1,0 9,7 9,7 1,0 1))")
    }
    
    func testBoundingBox_Throw () {
        XCTAssertTrue(true /* NOTE: Currently there are no cases that boundingBox throws.  It is marked with try to future proof it as boost evolves. */)
    }
    
    func testWithin () throws {
        let point   = try GFGeometry(wkt: "POINT(4 1)")
        let polygon = try GFGeometry(wkt: "POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))")
        
        XCTAssertTrue(try point.within(other: polygon))
    }
    
    func testWithin_Throws () throws {
        XCTAssertTrue(true /* NOTE: Currently there are no cases that within throws.  It is marked with try to future proof it as boost evolves. */)
    }
    
    func testIntersects_Self () throws {
        // Self crossing POlygon
        let polygon = try GFGeometry(wkt: "POLYGON((-91.5494 42.0698,-91.5494 42.0698,-91.549 42.0698,-91.5489 42.0697,-91.5488 42.0696,-91.5485 42.0696,-91.5481 42.0695,-91.5477 42.0694,-91.5475 42.0694,-91.5474 42.0693,-91.5472 42.0692,-91.547 42.0691,-91.547 42.0685,-91.547 42.0684,-91.5468 42.0682,-91.5467 42.0682,-91.5465 42.0681,-91.5463 42.0679,-91.5462 42.0678,-91.5461 42.0677,-91.546 42.0675,-91.5457 42.0674,-91.5456 42.0673,-91.5456 42.0672,-91.5456 42.0671,-91.5456 42.067,-91.5457 42.0669,-91.5458 42.0668,-91.546 42.0667,-91.5463 42.0666,-91.5464 42.0665,-91.5465 42.0664,-91.5465 42.0663,-91.5465 42.066,-91.5464 42.0657,-91.5464 42.0656,-91.5464 42.0655,-91.5465 42.0654,-91.5466 42.0652,-91.5469 42.065,-91.547 42.065,-91.547 42.0649,-91.547 42.0648,-91.5468 42.0647,-91.5477 42.0647,-91.5499 42.0647,-91.5499 42.0649,-91.5498 42.0648,-91.5495 42.0648,-91.5493 42.0648,-91.5491 42.0649,-91.5489 42.065,-91.5486 42.065,-91.5484 42.065,-91.5483 42.0651,-91.5483 42.0652,-91.5483 42.0653,-91.5485 42.0654,-91.5487 42.0654,-91.5489 42.0654,-91.549 42.0654,-91.5491 42.0655,-91.5491 42.0656,-91.5491 42.0657,-91.549 42.0657,-91.5489 42.0658,-91.5486 42.0658,-91.5484 42.0658,-91.5483 42.0658,-91.5481 42.0659,-91.5479 42.0661,-91.5479 42.0662,-91.5479 42.0664,-91.548 42.0665,-91.5481 42.0666,-91.5482 42.0667,-91.5485 42.0667,-91.549 42.0668,-91.5491 42.0668,-91.5491 42.0668,-91.5489 42.0668,-91.5489 42.0668,-91.5489 42.0673,-91.549 42.0679,-91.5492 42.0696,-91.5494 42.0698))")
        
        XCTAssertTrue(try polygon.intersects())
    }
    
    func testIntersects_Self_Throws () throws {
        XCTAssertTrue(true /* NOTE: Currently there are no cases that intersects self throws.  It is marked with try to future proof it as boost evolves. */)
    }
    
    func testIntersects_Other () throws {
        let lineString = try GFGeometry(wkt: "LINESTRING(1 1,2 2)")
        let polygon    = try GFGeometry(wkt: "POLYGON((0 0,10 0,10 10,0 10,0 0))")
        
        XCTAssertTrue(try lineString.intersects(other: polygon))
    }
    
    func testIntersects_Other_Throws () throws {
        XCTAssertTrue(true /* NOTE: Currently there are no cases that intersects other throws.  It is marked with try to future proof it as boost evolves. */)
    }
    
    func testUnion () throws {
        let polygon1 = try GFGeometry(wkt: "POLYGON((0 0,0 90,90 90,90 0,0 0))")
        let polygon2 = try GFGeometry(wkt: "POLYGON((120 0,120 90,210 90,210 0,120 0))")
        
        let result = try polygon1.union(other: polygon2)
        
        XCTAssertEqual(result.toWKTString(), "MULTIPOLYGON(((0 0,0 90,90 90,90 0,0 0)),((120 0,120 90,210 90,210 0,120 0)))")
    }
    
    func testUnion_Throw () throws {
        let multiPolygon = try GFGeometry(wkt: "MULTIPOLYGON(((-91.5354 42.0653,-91.5354 42.0653,-91.5356 42.0653,-91.5358 42.0652,-91.536 42.0651,-91.5362 42.0651,-91.5364 42.0651,-91.5368 42.0652,-91.5371 42.0651,-91.5375 42.0651,-91.5377 42.0651,-91.5378 42.0651,-91.5378 42.0652,-91.5379 42.0653,-91.5379 42.0654,-91.5378 42.0656,-91.5378 42.0656,-91.5377 42.0657,-91.5373 42.066,-91.5372 42.0661,-91.537 42.0664,-91.5369 42.0665,-91.5368 42.0666,-91.5365 42.0667,-91.5364 42.067,-91.5362 42.067,-91.5361 42.0672,-91.5358 42.0674,-91.5356 42.0675,-91.5354 42.0676,-91.5354 42.0653)),((-91.5499 42.0661,-91.5499 42.0666,-91.5499 42.067,-91.5497 42.067,-91.5496 42.0668,-91.5491 42.0668,-91.549 42.0668,-91.5485 42.0667,-91.5482 42.0667,-91.5481 42.0666,-91.548 42.0665,-91.5479 42.0664,-91.5479 42.0662,-91.5479 42.0661,-91.5481 42.0659,-91.5483 42.0658,-91.5484 42.0658,-91.5486 42.0658,-91.5489 42.0658,-91.549 42.0657,-91.5491 42.0657,-91.5491 42.0656,-91.5491 42.0655,-91.549 42.0654,-91.5489 42.0654,-91.5487 42.0654,-91.5485 42.0654,-91.5483 42.0653,-91.5483 42.0652,-91.5483 42.0651,-91.5484 42.065,-91.5486 42.065,-91.5489 42.065,-91.5491 42.0649,-91.5493 42.0648,-91.5495 42.0648,-91.5498 42.0648,-91.5499 42.0649,-91.5499 42.0661)),((-91.5379 42.0663,-91.538 42.0663,-91.5382 42.0665,-91.5383 42.0667,-91.5383 42.0668,-91.5383 42.0669,-91.5382 42.067,-91.538 42.0672,-91.5379 42.0672,-91.5381 42.0669,-91.5381 42.0666,-91.538 42.067,-91.5378 42.0673,-91.5377 42.0673,-91.5371 42.0676,-91.5369 42.0678,-91.5361 42.0678,-91.5363 42.0676,-91.5365 42.0674,-91.5369 42.0672,-91.5373 42.0669,-91.5374 42.0668,-91.5374 42.0668,-91.5376 42.0666,-91.5377 42.0664,-91.5378 42.0664,-91.5379 42.0663)),((-91.5368 42.0678,-91.5367 42.0679,-91.5366 42.068,-91.5364 42.0684,-91.5363 42.0685,-91.5362 42.0686,-91.5361 42.0687,-91.536 42.0687,-91.5357 42.0687,-91.5356 42.0686,-91.5354 42.0684,-91.5354 42.0684,-91.5354 42.0683,-91.5358 42.068,-91.5359 42.0679,-91.536 42.0678,-91.5368 42.0678)))")
        let polygon      = try GFGeometry(wkt: "POLYGON((-91.5494 42.0698,-91.5494 42.0698,-91.549 42.0698,-91.5489 42.0697,-91.5488 42.0696,-91.5485 42.0696,-91.5481 42.0695,-91.5477 42.0694,-91.5475 42.0694,-91.5474 42.0693,-91.5472 42.0692,-91.547 42.0691,-91.547 42.0685,-91.547 42.0684,-91.5468 42.0682,-91.5467 42.0682,-91.5465 42.0681,-91.5463 42.0679,-91.5462 42.0678,-91.5461 42.0677,-91.546 42.0675,-91.5457 42.0674,-91.5456 42.0673,-91.5456 42.0672,-91.5456 42.0671,-91.5456 42.067,-91.5457 42.0669,-91.5458 42.0668,-91.546 42.0667,-91.5463 42.0666,-91.5464 42.0665,-91.5465 42.0664,-91.5465 42.0663,-91.5465 42.066,-91.5464 42.0657,-91.5464 42.0656,-91.5464 42.0655,-91.5465 42.0654,-91.5466 42.0652,-91.5469 42.065,-91.547 42.065,-91.547 42.0649,-91.547 42.0648,-91.5468 42.0647,-91.5477 42.0647,-91.5499 42.0647,-91.5499 42.0649,-91.5498 42.0648,-91.5495 42.0648,-91.5493 42.0648,-91.5491 42.0649,-91.5489 42.065,-91.5486 42.065,-91.5484 42.065,-91.5483 42.0651,-91.5483 42.0652,-91.5483 42.0653,-91.5485 42.0654,-91.5487 42.0654,-91.5489 42.0654,-91.549 42.0654,-91.5491 42.0655,-91.5491 42.0656,-91.5491 42.0657,-91.549 42.0657,-91.5489 42.0658,-91.5486 42.0658,-91.5484 42.0658,-91.5483 42.0658,-91.5481 42.0659,-91.5479 42.0661,-91.5479 42.0662,-91.5479 42.0664,-91.548 42.0665,-91.5481 42.0666,-91.5482 42.0667,-91.5485 42.0667,-91.549 42.0668,-91.5491 42.0668,-91.5491 42.0668,-91.5489 42.0668,-91.5489 42.0668,-91.5489 42.0673,-91.549 42.0679,-91.5492 42.0696,-91.5494 42.0698))")
        
        XCTAssertThrowsError(try multiPolygon.union(other: polygon))
    }
    
    // MARK: Conversion not needed
    
    func testIsValid_True () {
        XCTAssertTrue(try GFGeometry(wkt: "POLYGON((0 0,0 7,4 2,2 0,0 0))").isValid())
    }
    
    func testIsValid_False () {
        // Self crossing POlygon
        XCTAssertFalse(try GFGeometry(wkt: "POLYGON((-91.5494 42.0698,-91.5494 42.0698,-91.549 42.0698,-91.5489 42.0697,-91.5488 42.0696,-91.5485 42.0696,-91.5481 42.0695,-91.5477 42.0694,-91.5475 42.0694,-91.5474 42.0693,-91.5472 42.0692,-91.547 42.0691,-91.547 42.0685,-91.547 42.0684,-91.5468 42.0682,-91.5467 42.0682,-91.5465 42.0681,-91.5463 42.0679,-91.5462 42.0678,-91.5461 42.0677,-91.546 42.0675,-91.5457 42.0674,-91.5456 42.0673,-91.5456 42.0672,-91.5456 42.0671,-91.5456 42.067,-91.5457 42.0669,-91.5458 42.0668,-91.546 42.0667,-91.5463 42.0666,-91.5464 42.0665,-91.5465 42.0664,-91.5465 42.0663,-91.5465 42.066,-91.5464 42.0657,-91.5464 42.0656,-91.5464 42.0655,-91.5465 42.0654,-91.5466 42.0652,-91.5469 42.065,-91.547 42.065,-91.547 42.0649,-91.547 42.0648,-91.5468 42.0647,-91.5477 42.0647,-91.5499 42.0647,-91.5499 42.0649,-91.5498 42.0648,-91.5495 42.0648,-91.5493 42.0648,-91.5491 42.0649,-91.5489 42.065,-91.5486 42.065,-91.5484 42.065,-91.5483 42.0651,-91.5483 42.0652,-91.5483 42.0653,-91.5485 42.0654,-91.5487 42.0654,-91.5489 42.0654,-91.549 42.0654,-91.5491 42.0655,-91.5491 42.0656,-91.5491 42.0657,-91.549 42.0657,-91.5489 42.0658,-91.5486 42.0658,-91.5484 42.0658,-91.5483 42.0658,-91.5481 42.0659,-91.5479 42.0661,-91.5479 42.0662,-91.5479 42.0664,-91.548 42.0665,-91.5481 42.0666,-91.5482 42.0667,-91.5485 42.0667,-91.549 42.0668,-91.5491 42.0668,-91.5491 42.0668,-91.5489 42.0668,-91.5489 42.0668,-91.5489 42.0673,-91.549 42.0679,-91.5492 42.0696,-91.5494 42.0698))").isValid())
    }
}
