/*
*   GFMultiPointTests.m
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

static NSDictionary * geoJSON1;
static NSDictionary * geoJSON2;
static NSDictionary * invalidGeoJSON;

//
// Static constructor
//
static __attribute__((constructor(101),used,visibility("internal"))) void staticConstructor (void) {
    geoJSON1       = @{@"type": @"MultiPoint", @"coordinates": @[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]]};
    geoJSON2       = @{@"type": @"MultiPoint", @"coordinates": @[@[@(103.0), @(2.0)],@[@(101.0), @(1.0)]]};
    invalidGeoJSON = @{@"type": @"MultiPoint", @"coordinates": @{}};
}

@interface GFMultiPointTests : XCTestCase
@end

@implementation GFMultiPointTests

#pragma mark - Test init

    - (void)testInit_NoThrow {
        XCTAssertNoThrow([[GFMultiPoint alloc] init]);
    }

    - (void)testInit_NotNil {
        XCTAssertNotNil([[GFMultiPoint alloc] init]);
    }

    - (void)testInit{
        XCTAssertEqualObjects([[[GFMultiPoint alloc] init] toWKTString], @"MULTIPOINT()");
    }

#pragma mark - Test initWithGeoJSONGeometry

    - (void) testInitWithGeoJSONGeometry_WithValidGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithGeoJSONGeometry: geoJSON1] toWKTString], @"MULTIPOINT((100 0),(101 1))");
    }

    - (void)testInitWithGeoJSONGeometry_WithInvalidGeoJSONGeometry {
        XCTAssertThrowsSpecificNamed([[GFMultiPoint alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test initWithWKT

    - (void) testInitWithWKT_WithValidWKT {
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((100 0),(101 1))"] toWKTString], @"MULTIPOINT((100 0),(101 1))");
    }

    - (void)testInitWithWKT_WithInvalidWKT {
        XCTAssertThrows([[GFMultiPoint alloc] initWithWKT: @"INVALID()"]);
    }

#pragma mark - Test copy

    - (void) testCopy {
        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((100 0),(101 1))"] copy] toWKTString], @"MULTIPOINT((100 0),(101 1))");
    }

#pragma mark - Test toGeoJSONGeometry

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

#pragma mark - Test description

    - (void) testDescription {
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithGeoJSONGeometry: geoJSON1] description], @"MULTIPOINT((100 0),(101 1))");
    }

#pragma mark - Test mapOverlays

    - (void) testMapOverlays {
        
        NSArray * mapOverlays = [[[GFMultiPoint alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 2);
        
        for (int i = 0; i < [mapOverlays count]; i++) {
            id mapOverlay = mapOverlays[i];
            
            XCTAssertTrue   ([mapOverlay isKindOfClass: [MKCircle class]]);
            
            MKCircle * circle = mapOverlay;
            
            XCTAssertTrue   ([circle coordinate].longitude == 100.0 + i);
            XCTAssertTrue   ([circle coordinate].latitude == 0.0 + i);
        }
    }

#pragma mark - Test count

    - (void) testCount_WithEmptyMultiPoint {
        XCTAssertEqual([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] count], 0);
    }

    - (void) testCount_With1ElementMultiPoint {
        XCTAssertEqual([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1))"] count], 1);
    }

    - (void) testCount_With2ElementMultiPoint {
        XCTAssertEqual([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] count], 2);
    }

#pragma mark - Test pointAtIndex

    - (void) testPointAtIndex_With2ElementMultiPointAndIndex0 {
        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] geometryAtIndex: 0] toWKTString], @"POINT(1 1)");
    }

    - (void) testPointAtIndex_With2ElementMultiPointAndIndex1 {
        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] geometryAtIndex: 1] toWKTString], @"POINT(2 2)");
    }

    - (void) testPointAtIndex_With2ElementMultiPointAndOutOfRangeIndex {
        XCTAssertThrowsSpecificNamed(([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1))"] geometryAtIndex: 1]), NSException, NSRangeException);
    }

#pragma mark - Test firstPoint

    - (void) testFirstPoint_With2ElementMultiPoint {
        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] firstGeometry] toWKTString], @"POINT(1 1)");
    }

    - (void) testFirstPoint_WithEmptyMultiPoint_NoThrow {
        XCTAssertNoThrow([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] firstGeometry]);
    }

    - (void) testFirstPoint_WithEmptyMultiPoint {
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] firstGeometry], nil);
    }

#pragma mark - Test lastPoint

    - (void) testLastPoint_With2ElementMultiPoint {
        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] lastGeometry] toWKTString], @"POINT(2 2)");
    }

    - (void) testLastPoint_WithEmptyMultiPoint_NoThrow {
        XCTAssertNoThrow([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] lastGeometry]);
    }

    - (void) testLastPoint_WithEmptyMultiPoint {
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] lastGeometry], nil);
    }

#pragma mark - Test objectAtIndexedSubscript

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPointAndIndex0_NoThrow {
        GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"];

        XCTAssertNoThrow(multiPoint[0]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPointAndIndex0 {
        GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"];

        XCTAssertEqualObjects([multiPoint[0] toWKTString], @"POINT(1 1)");
    }

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPointAndIndex1_NoThrow {
        GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"];

        XCTAssertNoThrow(multiPoint[1]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPointAndIndex1 {
        GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"];

        XCTAssertEqualObjects([multiPoint[1] toWKTString], @"POINT(2 2)");
    }

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPointAndOutOfRangeIndex {
        GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"];

        XCTAssertThrowsSpecificNamed(multiPoint[2], NSException, NSRangeException);
    }

@end


