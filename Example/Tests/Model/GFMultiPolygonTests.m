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

    - (void)testConstruction {
        XCTAssertNoThrow([[GFMultiPolygon alloc] init]);
        XCTAssertNotNil([[GFMultiPolygon alloc] init]);
    }

    - (void)testFailedConstruction {
        XCTAssertThrowsSpecificNamed([[GFMultiPolygon alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
        XCTAssertThrows([[GFMultiPolygon alloc] initWithWKT: @"INVALID()"]);
    }

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

    - (void) testDescription {
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] description], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

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

#pragma mark - Querying Tests

    - (void) testCount {

        XCTAssertEqual([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] count], 0);
        XCTAssertEqual([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)))"] count], 1);
        XCTAssertEqual([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] count], 2);
    }

    - (void) testObjectAtIndex {

        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] geometryAtIndex: 0] toWKTString], @"POLYGON((20 0,20 10,40 10,40 0,20 0))");
        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] geometryAtIndex: 1] toWKTString], @"POLYGON((5 5,5 8,8 8,8 5,5 5))");

        XCTAssertThrowsSpecificNamed(([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)))"] geometryAtIndex: 1]), NSException, NSRangeException);
    }

    - (void) testFirstObject {

        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] firstGeometry] toWKTString], @"POLYGON((20 0,20 10,40 10,40 0,20 0))");

        XCTAssertNoThrow([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] firstGeometry]);
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] firstGeometry], nil);
    }

    - (void) testLastObject {

        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] lastGeometry] toWKTString], @"POLYGON((5 5,5 8,8 8,8 5,5 5))");

        XCTAssertNoThrow([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] lastGeometry]);
        XCTAssertEqualObjects([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON()"] lastGeometry], nil);
    }

#pragma mark - Indexed Subscripting Tests

    - (void) testObjectAtIndexedSubscript {

        GFMultiPolygon * multiPolygon = [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"];

        XCTAssertNoThrow(multiPolygon[0]);
        XCTAssertNoThrow(multiPolygon[1]);
        XCTAssertThrowsSpecificNamed(multiPolygon[2], NSException, NSRangeException);

        XCTAssertEqualObjects([multiPolygon[0] toWKTString], @"POLYGON((20 0,20 10,40 10,40 0,20 0))");
        XCTAssertEqualObjects([multiPolygon[1] toWKTString], @"POLYGON((5 5,5 8,8 8,8 5,5 5))");
    }

@end
