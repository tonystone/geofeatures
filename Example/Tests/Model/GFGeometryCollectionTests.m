/*
*   GFMultiPolygonTests.m
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
*   Created by Tony Stone on 08/29/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFGeometryCollectionTests : XCTestCase
@end

static NSDictionary * geoJSON;
static NSDictionary * invalidGeoJSON;

static void __attribute__((constructor)) staticInitializer() {

    geoJSON  = @{
            @"type": @"GeometryCollection",
            @"geometries": @[
                    // Note: GeoJSON does not support a box type so we don't test it here.
                    @{@"type": @"Point", @"coordinates": @[@(100.0), @(0.0)]},
                    @{@"type": @"LineString", @"coordinates": @[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]]},
                    @{@"type": @"Polygon",
                            @"coordinates": @[
                            @[ @[@(100.0), @(0.0)], @[@(200.0), @(100.0)],@[@(200.0), @(0.0)], @[@(100.0), @(1.0)], @[@(100.0), @(0.0)] ],
                            @[ @[@(100.2), @(0.2)], @[@(100.8), @(0.2)],  @[@(100.8), @(0.8)], @[@(100.2), @(0.8)], @[@(100.2), @(0.2)] ]]
                    },
                    @{@"type": @"MultiPoint", @"coordinates": @[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]]},
                    @{@"type": @"MultiLineString", @"coordinates": @[@[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]], @[@[@(102.0), @(2.0)],@[@(103.0), @(3.0)]]]},
                    @{@"type": @"MultiPolygon",
                            @"coordinates": @[
                            @[
                                    @[@[@(102.0), @(2.0)], @[@(102.0), @(3.0)], @[@(103.0), @(3.0)], @[@(103.0), @(2.0)], @[@(102.0), @(2.0)]]
                            ],
                            @[
                                    @[@[@(100.0), @(0.0)], @[@(101.0), @(1.0)], @[@(100.0), @(1.0)], @[@(101.0), @(0.0)], @[@(100.0), @(0.0)]],
                                    @[@[@(100.2), @(0.2)], @[@(100.8), @(0.2)], @[@(100.8), @(0.8)], @[@(100.2), @(0.8)], @[@(100.2), @(0.2)]]
                            ]]
                    },
                    @{@"type": @"GeometryCollection",
                            @"geometries": @[
                            @{@"type": @"Point", @"coordinates": @[@(100.0), @(0.0)]},
                            @{@"type": @"LineString", @"coordinates": @[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]]}
                        ]
                    }
            ]
    };
    invalidGeoJSON = @{@"type": @"GeometryCollection", @"coordinates": @{}};
}

@implementation GFGeometryCollectionTests

#pragma mark - Test Init

    - (void)testInit_NoThrow {
        XCTAssertNoThrow([[GFGeometryCollection alloc] init]);
    }

    - (void)testInit_NotNil {
        XCTAssertNotNil([[GFGeometryCollection alloc] init]);
    }

#pragma mark - Test initGeoJSONGeometry

    - (void) testInitWithGeoJSONGeometry_NoThrow {
        XCTAssertNoThrow([[GFGeometryCollection alloc] initWithGeoJSONGeometry: geoJSON]);
    }

    - (void) testInitWithGeoJSONGeometry_NotNil {
        XCTAssertNotNil([[GFGeometryCollection alloc] initWithGeoJSONGeometry: geoJSON]);
    }

    - (void) testInitWithGeoJSONGeometry_WithValidGeoJSON {
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithGeoJSONGeometry: geoJSON] toWKTString], @"GEOMETRYCOLLECTION(POINT(100 0),LINESTRING(100 0,101 1),POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)),MULTIPOINT((100 0),(101 1)),MULTILINESTRING((100 0,101 1),(102 2,103 3)),MULTIPOLYGON(((102 2,102 3,103 3,103 2,102 2)),((100 0,101 1,100 1,101 0,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))),GEOMETRYCOLLECTION(POINT(100 0),LINESTRING(100 0,101 1)))");
    }

    - (void) testInitWithGeoJSONGeometry_WithInvalidGeoJSON {
        XCTAssertThrowsSpecificNamed([[GFGeometryCollection alloc] initWithGeoJSONGeometry:  invalidGeoJSON], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test InitWithArray

    - (void) testInitWithArray_WithEmptyArray_NoThrow {
        XCTAssertNoThrow([[GFGeometryCollection alloc] initWithArray: @[]]);
    }

    - (void) testInitWithArray_WithEmptyArray_NotNil {
        XCTAssertNotNil ([[GFGeometryCollection alloc] initWithArray: @[]]);
    }

    - (void) testInitWithArray_WithValidArray_NoThrow {
        XCTAssertNoThrow([[GFGeometryCollection alloc] initWithArray: (@[
                [[GFPoint alloc] initWithWKT: @"POINT(103 2)"],
                [[GFBox alloc] initWithWKT: @"BOX(1 1,3 3)"],
                [[GFLineString alloc] initWithWKT: @"LINESTRING(40 50,40 140)"],
                [[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"],
                [[GFPolygon alloc] initWithWKT: @"POLYGON((120 0,120 90,210 90,210 0,120 0))"],
                [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((100 0),(101 1))"],
                [[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((100 0,101 1),(102 2,103 3))"],
                [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"]
        ])]);
    }
    - (void) testInitWithArray_WithValidArray {
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithArray: (@[
                [[GFPoint alloc] initWithWKT: @"POINT(103 2)"],
                [[GFBox alloc] initWithWKT: @"BOX(1 1,3 3)"],
                [[GFLineString alloc] initWithWKT: @"LINESTRING(40 50,40 140)"],
                [[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"],  // Ring is returning a polygon
                [[GFPolygon alloc] initWithWKT: @"POLYGON((120 0,120 90,210 90,210 0,120 0))"],
                [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((100 0),(101 1))"],
                [[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((100 0,101 1),(102 2,103 3))"],
                [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"]
        ])] toWKTString],
                @"GEOMETRYCOLLECTION(POINT(103 2),POLYGON((1 1,1 3,3 3,3 1,1 1)),LINESTRING(40 50,40 140),LINESTRING(20 0,20 10,40 10,40 0,20 0),POLYGON((120 0,120 90,210 90,210 0,120 0)),MULTIPOINT((100 0),(101 1)),MULTILINESTRING((100 0,101 1),(102 2,103 3)),MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5))))"
        );
    }

    - (void) testInitWithArray_WithInvalidArray {
        XCTAssertThrowsSpecificNamed([[GFGeometryCollection alloc] initWithArray: (@[ [[NSObject alloc] init]])], NSException, NSInvalidArgumentException);
    }

    - (void) testInitWithArray_WithInvalidObject {
        XCTAssertThrowsSpecificNamed([[GFGeometryCollection alloc] initWithArray: @[[[NSObject alloc] init]]], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test InitWithWKT

    - (void)testInitWithWKT_WithInvalidWKT {
//        XCTAssertThrowsSpecificNamed([[GFGeometryCollection alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
        XCTAssertThrows([[GFGeometryCollection alloc] initWithWKT: @"INVALID()"]);
    }

#pragma mark - Test copy

    - (void) testCopy {
        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))"] \
                                    copy] toWKTString], @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }

#pragma mark - Test description

    - (void) testDescription {
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithWKT:
                @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))"] description],
                @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }

#pragma mark - Test count

    - (void) testCount_WithEmptyGeometryCollection {
        XCTAssertEqual([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] count], 0);
    }

    - (void) testCount_With1ElementGeometryCollection {
        XCTAssertEqual([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)))"] count], 1);
    }

    - (void) testCount_With2ElementGeometryCollection {
        XCTAssertEqual([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] count], 2);
    }

#pragma mark - Test objectAtIndex

    - (void) testObjectAtIndex_With2ElementGeometryCollectionAndIndex0 {
        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] geometryAtIndex: 0] toWKTString], @"POLYGON((120 0,120 90,210 90,210 0,120 0))");
    }

    - (void) testObjectAtIndex_With2ElementGeometryCollectionAndIndex1 {
        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] geometryAtIndex: 1] toWKTString], @"LINESTRING(40 50,40 140)");
    }

    - (void) testObjectAtIndex_With1ElementGeometryCollectionAndIndex1 {
        XCTAssertThrowsSpecificNamed(([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)))"] geometryAtIndex: 1]), NSException, NSRangeException);
    }

#pragma mark - Test firstGeometry

    - (void) testFirstGeometry_With2ElementGeometryCollection {
        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] firstGeometry] toWKTString], @"POLYGON((120 0,120 90,210 90,210 0,120 0))");
    }

    - (void) testFirstGeometry_WithEmptyGeometryCollection_NoThrow {
        XCTAssertNoThrow([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] firstGeometry]);
    }

    - (void) testFirstGeometry_WithEmptyGeometryCollection  {
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] firstGeometry], nil);
    }

#pragma mark - Test lastGeometry

    - (void) testLastGeometry_With2ElementGeometryCollection {
        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] lastGeometry] toWKTString], @"LINESTRING(40 50,40 140)");
    }

    - (void) testLastGeometry_WithEmptyGeometryCollection_NoThrow {
        XCTAssertNoThrow([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] lastGeometry]);
    }

    - (void) testLastGeometry_WithEmptyGeometryCollection {
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] lastGeometry], nil);
    }

#pragma mark - Test objectAtIndexedSubscript

    - (void) testObjectAtIndexedSubscript_With2ElementGeometryCollectionAndIndexInRange {

        GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"];

        XCTAssertNoThrow(geometryCollection[0]);
        XCTAssertNoThrow(geometryCollection[1]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementGeometryCollectionAndIndexOutOfRangeRange  {

        GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"];

        XCTAssertThrowsSpecificNamed(geometryCollection[2], NSException, NSRangeException);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementGeometryCollectionAndIndex0  {

        GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"];

        XCTAssertEqualObjects([geometryCollection[0] toWKTString], @"POLYGON((120 0,120 90,210 90,210 0,120 0))");
    }

    - (void) testObjectAtIndexedSubscript_With2ElementGeometryCollectionAndIndex1  {

        GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"];

        XCTAssertEqualObjects([geometryCollection[1] toWKTString], @"LINESTRING(40 50,40 140)");
    }

@end
