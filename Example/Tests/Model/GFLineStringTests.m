/*
*   GFLineStringTests.m
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
    geoJSON1       = @{@"type": @"LineString", @"coordinates": @[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]]};
    geoJSON2       = @{@"type": @"LineString", @"coordinates": @[@[@(102.0), @(0.0)],@[@(102.0), @(1.0)]]};
    invalidGeoJSON = @{@"type": @"LineString", @"coordinates": @{}};
}

@interface GFLineStringTests : XCTestCase
@end

@implementation GFLineStringTests

#pragma mark - Test init

    - (void)testInit_NoThrow {
        XCTAssertNoThrow([[GFLineString alloc] init]);
    }

    - (void)testInit_NotNil {
        XCTAssertNotNil([[GFLineString alloc] init]);
    }

#pragma mark - Test initWithGeoJSONGeometry

    - (void) testInitWithGeoJSONGeometry_WithInvalidGeoJSON {
        XCTAssertThrowsSpecificNamed([[GFLineString alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test initWithWKT

    - (void) testInitWithWKT_WithInvalidWKT {
        XCTAssertThrows([[GFLineString alloc] initWithWKT: @"INVALID()"]);
    }

#pragma mark - Test copy

    - (void) testCopy {
        XCTAssertEqualObjects([[[[GFLineString alloc] initWithWKT: @"LINESTRING(100 0,101 1)"] copy] toWKTString], @"LINESTRING(100 0,101 1)");
    }

#pragma mark - Test toGeoJSONGeometry

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFLineString alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

#pragma mark - Test description

    - (void) testDescription_WithGeoJSON1 {
        XCTAssertEqualObjects([[[GFLineString alloc] initWithGeoJSONGeometry: geoJSON1] description], @"LINESTRING(100 0,101 1)");
    }

    - (void) testDescription_WithGeoJSON2 {
        XCTAssertEqualObjects([[[GFLineString alloc] initWithGeoJSONGeometry: geoJSON2] description], @"LINESTRING(102 0,102 1)");
    }

#pragma mark - Test mapOverlays

    - (void) testMapOverlays {
    
        NSArray * mapOverlays = [[[GFLineString alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);
        
        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKPolyline class]]);
        
        MKPolyline * polyline = (MKPolyline *) [mapOverlays lastObject];
        
        XCTAssertTrue   ([polyline pointCount] == 2);
    }

#pragma mark - Test count

    - (void) testCount_WithEmptyLineString {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING()"] count], 0);
    }

    - (void) testCount_With1ElementLineString {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING(40 60)"] count], 1);
    }

    - (void) testCount_With2ElementLineString {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"] count], 2);
    }

#pragma mark - Test objectAtIndex

    - (void) testObjectAtIndex_With2ElementLineStringAndIndex0 {
        XCTAssertEqualObjects([[[[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"] pointAtIndex: 0] toWKTString], @"POINT(40 60)");
    }

    - (void) testObjectAtIndex_With2ElementLineStringAndIndex1  {
        XCTAssertEqualObjects([[[[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"] pointAtIndex: 1] toWKTString], @"POINT(120 110)");
    }

    - (void) testObjectAtIndex_With1ElementLineStringAndOutOfRangeIndex  {
        XCTAssertThrowsSpecificNamed(([[[GFLineString alloc] initWithWKT: @"LINESTRING(40 60)"] pointAtIndex: 1]), NSException, NSRangeException);
    }

#pragma mark - Test firstObject

    - (void) testFirstObject_With2ElementLineString {
        XCTAssertEqualObjects([[[[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"] firstPoint] toWKTString], @"POINT(40 60)");
    }

    - (void) testFirstObject_WithEmptyLineString_NoThrow {
        XCTAssertNoThrow([[[GFLineString alloc] initWithWKT: @"LINESTRING()"] firstPoint]);
    }

    - (void) testFirstObject_WithEmptyLineString {
        XCTAssertEqualObjects([[[GFLineString alloc] initWithWKT: @"LINESTRING()"] firstPoint], nil);
    }

#pragma mark - Test lastObject

    - (void) testLastObject_With2ElementLineString  {
        XCTAssertEqualObjects([[[[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"] lastPoint] toWKTString], @"POINT(120 110)");
    }

    - (void) testLastObject_WithEmptyLineString_NoThrow  {
        XCTAssertNoThrow([[[GFLineString alloc] initWithWKT: @"LINESTRING()"] lastPoint]);
    }

    - (void) testLastObject_WithEmptyLineString  {
        XCTAssertEqualObjects([[[GFLineString alloc] initWithWKT: @"LINESTRING()"] lastPoint], nil);
    }

#pragma mark - Test objectAtIndexSubscript

    - (void) testObjectAtIndexedSubscript_With2ElementLineStringAndIndex0_NoThrow {
        GFLineString * lineString = [[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"];

        XCTAssertNoThrow(lineString[0]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementLineStringAndIndex1_NoThrow {
        GFLineString * lineString = [[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"];

        XCTAssertNoThrow(lineString[1]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementLineStringAndIndex0 {
        GFLineString * lineString = [[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"];

        XCTAssertEqualObjects([lineString[0] toWKTString], @"POINT(40 60)");
    }

    - (void) testObjectAtIndexedSubscript_With2ElementLineStringAndIndex1 {
        GFLineString * lineString = [[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"];

        XCTAssertEqualObjects([lineString[1] toWKTString], @"POINT(120 110)");
    }

    - (void) testObjectAtIndexedSubscript_With2ElementLineStringAndOutOfRangeIndex {
        GFLineString * lineString = [[GFLineString alloc] initWithWKT: @"LINESTRING(40 60,120 110)"];

        XCTAssertThrowsSpecificNamed(lineString[2], NSException, NSRangeException);
    }

@end

