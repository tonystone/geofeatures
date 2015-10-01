/*
*   GFRingTests.m
*
*   Copyright 2015 Tony Stone
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
*   Created by Tony Stone on 04/14/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFRingTests : XCTestCase
@end

static NSDictionary * geoJSON1;
static NSDictionary * geoJSON2;


void __attribute__((constructor)) staticInitializer() {
    
    geoJSON1  = @{
                  @"type": @"LineString",
                  @"coordinates": @[ @[@(100.0), @(0.0)], @[@(101.0), @(1.0)]]
                  };
    geoJSON2 = @{
                 @"type": @"LineString",
                 @"coordinates": @[ @[@(102.0), @(0.0)], @[@(102.0), @(1.0)]]
                 };
}

@implementation GFRingTests

#pragma mark - Test init

    - (void)testInit_NoThrow {
        XCTAssertNoThrow([[GFRing alloc] init]);
    }

    - (void)testInit_NotNil {
        XCTAssertNotNil([[GFRing alloc] init]);
    }

    - (void)testInit {
        XCTAssertEqualObjects([[[GFRing alloc] init] toWKTString], @"LINESTRING()");
    }

#pragma mark - Test initWithGeoJSONGeometry

    - (void)testInitWithGeoJSONGeometry_WithInvalidGeoJSONGeometry {
        XCTAssertThrowsSpecificNamed(([[GFRing alloc] initWithGeoJSONGeometry: @{@"invalid": @{}}]), NSException, NSInvalidArgumentException);
    }

#pragma mark - Test initWithWKT

    - (void)testInitWithWKT_WithInvalidWKT {
        XCTAssertThrows([[GFRing alloc] initWithWKT: @"INVALID()"]);
    }

#pragma mark - Test copy

    - (void) testCopy {
        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] copy] toWKTString], @"LINESTRING(20 0,20 10,40 10,40 0,20 0)");
    }

#pragma mark - Test description

    - (void) testDescription_NotNil {
        XCTAssertNotNil([[[GFRing alloc] initWithGeoJSONGeometry: geoJSON1] description]);
    }

    - (void) testDescription {
        XCTAssertEqualObjects ([[[GFRing alloc] initWithGeoJSONGeometry: geoJSON1] description],@"LINESTRING(100 0,101 1)");
    }

#pragma mark - Test toGeoJSONGeometry

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFRing alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

#pragma mark - Test mapOverlays

    - (void) testMapOverlays {
    
        NSArray * mapOverlays = [[[GFRing alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);
        
        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKPolyline class]]);
        
        MKPolyline * polyline = (MKPolyline *) [mapOverlays lastObject];
        
        XCTAssertTrue   ([polyline pointCount] == 2);
    }

#pragma mark - Test count

    - (void) testCount_WithEmptyRing {
        XCTAssertEqual([[[GFRing alloc] initWithWKT: @"LINESTRING()"] count], 0);
    }

    - (void) testCount_With5ElementRing {
        XCTAssertEqual([[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] count], 5);
    }

#pragma mark - Test pointAtIndex

    - (void) testPointAtIndex_With5ElementLineRingAndIndex0 {
        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] pointAtIndex: 0] toWKTString], @"POINT(20 0)");
    }

    - (void) testPointAtIndex_With5ElementLineRingAndIndex1 {
        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] pointAtIndex: 1] toWKTString], @"POINT(20 10)");
    }

    - (void) testPointAtIndex_With5ElementLineRingAndOutOfRangeIndex {
        XCTAssertThrowsSpecificNamed(([[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] pointAtIndex: 5]), NSException, NSRangeException);
    }

#pragma mark - Test firstPoint

    - (void) testFirstPoint_With5ElementLineRing {
        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] firstPoint] toWKTString], @"POINT(20 0)");
    }

    - (void) testFirstPoint_With5ElementLineRing_NoThrow {
        XCTAssertNoThrow([[[GFRing alloc] initWithWKT: @"LINESTRING()"] firstPoint]);
    }

    - (void) testFirstPoint_WithEmptyLineRing {
        XCTAssertEqualObjects([[[GFRing alloc] initWithWKT: @"LINESTRING()"] firstPoint], nil);
    }

#pragma mark - Test lastPoint

    - (void) testLastPoint_With5ElementLineRing {
        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] lastPoint] toWKTString], @"POINT(20 0)");
    }

    - (void) testLastPoint_With5ElementLineRing_NoThrow  {
        XCTAssertNoThrow([[[GFRing alloc] initWithWKT: @"LINESTRING()"] lastPoint]);
    }

    - (void) testLastPoint_WithEmptyLineRing {
        XCTAssertEqualObjects([[[GFRing alloc] initWithWKT: @"LINESTRING()"] lastPoint], nil);
    }

#pragma mark - Test objectAtIndexedSubscript

    - (void) testObjectAtIndexedSubscript_With2ElementRingAndIndex0_NoThrow {
        GFRing * ring = [[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"];

        XCTAssertNoThrow(ring[0]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementRingAndIndex1_NoThrow {
        GFRing * ring = [[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"];

        XCTAssertNoThrow(ring[1]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementRingAndIndex0 {
        GFRing * ring = [[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"];

        XCTAssertEqualObjects([ring[0] toWKTString], @"POINT(20 0)");
    }

    - (void) testObjectAtIndexedSubscript_With2ElementRingAndIndex1 {
        GFRing * ring = [[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"];

        XCTAssertEqualObjects([ring[1] toWKTString], @"POINT(20 10)");
    }

    - (void) testObjectAtIndexedSubscript_WithOutOfRangeIndex {
        GFRing * ring = [[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"];

        XCTAssertThrowsSpecificNamed(ring[5], NSException, NSRangeException);
    }

@end

