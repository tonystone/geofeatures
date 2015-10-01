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
    geoJSON1 = @{
            @"type": @"MultiPolygon",
            @"coordinates": @[
                    @[
                            @[@[@(102.0), @(2.0)], @[@(102.0), @(3.0)], @[@(103.0), @(3.0)], @[@(103.0), @(2.0)], @[@(102.0), @(2.0)]]
                    ],
                    @[
                            @[@[@(100.0), @(0.0)], @[@(101.0), @(1.0)], @[@(100.0), @(1.0)], @[@(101.0), @(0.0)], @[@(100.0), @(0.0)]],
                            @[@[@(100.2), @(0.2)], @[@(100.8), @(0.2)], @[@(100.8), @(0.8)], @[@(100.2), @(0.8)], @[@(100.2), @(0.2)]]
                    ]
            ]
    };
    geoJSON2 = @{
            @"type" : @"MultiPolygon",
            @"coordinates" : @[
                    @[@[@[@(103.0), @(2.0)], @[@(104.0), @(2.0)], @[@(104.0), @(3.0)], @[@(103.0), @(3.0)], @[@(103.0), @(2.0)]]],
                    @[@[@[@(100.0), @(0.0)], @[@(101.0), @(0.0)], @[@(101.0), @(1.0)], @[@(100.0), @(1.0)], @[@(100.0), @(0.0)]],
                            @[@[@(100.2), @(0.2)], @[@(100.8), @(0.2)], @[@(100.8), @(0.8)], @[@(100.2), @(0.8)], @[@(100.2), @(0.2)]]]
            ]
    };

    invalidGeoJSON = @{@"type": @"MultiLineString", @"coordinates": @{}};
}

@interface GFMultiPolygonTests : XCTestCase
@end

@implementation GFMultiPolygonTests

#pragma mark - Test init

    - (void)testInit_NoThrow {
        XCTAssertNoThrow([[GFMultiPolygon alloc] init]);
    }

    - (void)testInit_NotNil {
        XCTAssertNotNil([[GFMultiPolygon alloc] init]);
    }

    - (void)testInit {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] init] toWKTString], @"MULTIPOLYGON()");
    }

#pragma mark - Test initWithGeoJSONGeometry

    - (void) testInitWIthGeoJSONGeometry_WithValidGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithGeoJSONGeometry: geoJSON1] toWKTString], @"MULTIPOLYGON(((102 2,102 3,103 3,103 2,102 2)),((100 0,101 1,100 1,101 0,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)))");
    }

    - (void)testInitWithGeoJSONGeometry_WithInvalidGeoJSONGeometry {
        XCTAssertThrowsSpecificNamed([[GFMultiPolygon alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test initWithWKT

    - (void) testInitWithWKT_WithValidWKT {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] toWKTString], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void)testInitWithWKT_WithInvalidWKT {
        XCTAssertThrows([[GFMultiPolygon alloc] initWithWKT: @"INVALID()"]);
    }

#pragma mark - Test copy

    - (void) testCopy {
        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] copy] toWKTString], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

#pragma mark - Test toGeoJSONGeometry

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

#pragma mark - Test description

    - (void) testDescription {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] description], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

#pragma mark - Test mapOverlays

    - (void) testMapOverlays {
        
        NSArray * mapOverlays = [[[GFMultiPolygon alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 2);
        
        for (int i = 0; i < [mapOverlays count]; i++) {
            id mapOverlay = mapOverlays[i];
            
            XCTAssertTrue   ([mapOverlay isKindOfClass: [MKPolygon class]]);
            
            MKPolygon * polygon = mapOverlay;
            
            XCTAssertTrue   ([polygon pointCount] == 5);
            
            if (i == 0) {
                XCTAssertTrue ([[polygon interiorPolygons] count] == 0);
            } else {
                XCTAssertTrue ([[polygon interiorPolygons] count] == 1);
            }
        }
    }

#pragma mark - Test count

    - (void) testCount_WithEmptyMultiPolygon {
        XCTAssertEqual([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] count], 0);
    }

    - (void) testCount_With1ElementMultiPolygon {
        XCTAssertEqual([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)))"] count], 1);
    }

    - (void) testCount_With2ElementMultiPolygon {
        XCTAssertEqual([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] count], 2);
    }

#pragma mark - Test geometryAtIndex

    - (void) testGeometryAtIndex_With2ElementMultiPolygonAndIndex0 {
        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] geometryAtIndex: 0] toWKTString], @"POLYGON((20 0,20 10,40 10,40 0,20 0))");
    }

    - (void) testGeometryAtIndex_With2ElementMultiPolygonAndIndex1 {
        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] geometryAtIndex: 1] toWKTString], @"POLYGON((5 5,5 8,8 8,8 5,5 5))");
    }

    - (void) testGeometryAtIndex_With2ElementMultiPolygonAndOutOfRangeIndex {
        XCTAssertThrowsSpecificNamed(([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)))"] geometryAtIndex: 1]), NSException, NSRangeException);
    }

#pragma mark - Test firstGeometry

    - (void) testFirstGeometry_With2ElementMultiPolygon {
        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] firstGeometry] toWKTString], @"POLYGON((20 0,20 10,40 10,40 0,20 0))");
    }

    - (void) testFirstGeometry_WithEmptyMultiPolygon_NoThrow {
        XCTAssertNoThrow([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] firstGeometry]);
    }

    - (void) testFirstGeometry_WithEmptyMultiPolygon {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] firstGeometry], nil);
    }

#pragma mark - Test lastGeometry

    - (void) testLastGeometry_With2ElementMultiPolygon {
        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] lastGeometry] toWKTString], @"POLYGON((5 5,5 8,8 8,8 5,5 5))");
    }

    - (void) testLastGeometry_WithEmptyMultiPolygon_NoThrow {
        XCTAssertNoThrow([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] lastGeometry]);
    }

    - (void) testLastGeometry_WithEmptyMultiPolygon {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] lastGeometry], nil);
    }

#pragma mark - Test objectAtIndexedSubscript

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPolygonAndIndex0_NoThrow {
        GFMultiPolygon * multiPolygon = [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"];

        XCTAssertNoThrow(multiPolygon[0]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPolygonAndIndex0 {
        GFMultiPolygon * multiPolygon = [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"];

        XCTAssertEqualObjects([multiPolygon[0] toWKTString], @"POLYGON((20 0,20 10,40 10,40 0,20 0))");
    }

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPolygonAndIndex1_NoThrow {
        GFMultiPolygon * multiPolygon = [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"];

        XCTAssertNoThrow(multiPolygon[1]);
    }

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPolygonAndIndex1 {
        GFMultiPolygon * multiPolygon = [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"];

        XCTAssertEqualObjects([multiPolygon[1] toWKTString], @"POLYGON((5 5,5 8,8 8,8 5,5 5))");
    }

    - (void) testObjectAtIndexedSubscript_With2ElementMultiPolygonAndOutOfRangeIndex {
        GFMultiPolygon * multiPolygon = [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"];

        XCTAssertThrowsSpecificNamed(multiPolygon[2], NSException, NSRangeException);
    }

@end
