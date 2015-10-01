/*
*   GFBoxBoxTests.m
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

@interface GFBoxTests : XCTestCase
@end

static NSDictionary * geoJSON1;
static NSDictionary * geoJSON2;
static NSDictionary * invalidGeoJSON;

//
// Static constructor
//
static __attribute__((constructor(101),used,visibility("internal"))) void staticConstructor (void) {
    geoJSON1       = @{@"type": @"Box", @"coordinates": @[@[@(1.0), @(1.0)],@[@(3.0), @(3.0)]]};
    geoJSON2       = @{@"type": @"Box", @"coordinates": @[@[@(103.0), @(2.0)],@[@(110.0), @(4.0)]]};
    invalidGeoJSON = @{@"type": @"Box", @"coordinates": @{}};
}

@implementation GFBoxTests

#pragma mark - Test init

    - (void)testInit_NoThrow {
        XCTAssertNoThrow([[GFBox alloc] init]);
    }

    - (void)testInit_NotNil {
        XCTAssertNotNil([[GFBox alloc] init]);
    }

    - (void) testInit {
        XCTAssertEqualObjects([[[GFBox alloc] init] toWKTString], @"POLYGON((0 0,0 0,0 0,0 0,0 0))");
    }

#pragma mark - Test initWithMinCornerMaxCorner

    - (void) testInitWithMinCornerMaxCorner_NoThrow {
        XCTAssertNoThrow([[GFBox alloc] initWithMinCorner: [[GFPoint alloc] initWithX:100.0 y: 0.0] maxCorner: [[GFPoint alloc] initWithX: 101.0 y:1.0]]);
    }

    - (void) testInitWithMinCornerMaxCorner_NotNil {
        XCTAssertNotNil([[GFBox alloc] initWithMinCorner: [[GFPoint alloc] initWithX:100.0 y: 0.0] maxCorner: [[GFPoint alloc] initWithX: 101.0 y:1.0]]);
    }

    - (void) testInitWithMinCornerMaxCorner_WithValidCorners {
        XCTAssertEqualObjects([[[GFBox alloc] initWithMinCorner: [[GFPoint alloc] initWithX: 1.0 y: 1.0] maxCorner: [[GFPoint alloc] initWithX: 3.0 y: 3.0]] toWKTString], @"POLYGON((1 1,1 3,3 3,3 1,1 1))");
    }

#pragma mark - Test initGeoJSONGeometry

    - (void) testInitWithGeoJSONGeometry_NoThrow {
        XCTAssertNoThrow([[GFBox alloc] initWithGeoJSONGeometry: geoJSON1]);
    }

    - (void) testInitWithGeoJSONGeometry_NotNil {
        XCTAssertNotNil([[GFBox alloc] initWithGeoJSONGeometry: geoJSON1]);
    }

    - (void) testInitWithGeoJSONGeometry_WithValidGeoJSON {
        XCTAssertEqualObjects([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON1] toWKTString], @"POLYGON((1 1,1 3,3 3,3 1,1 1))");
    }

    - (void) testInitWithGeoJSONGeometry_WithInvalidGeoJSON {
        XCTAssertThrowsSpecificNamed([[GFBox alloc] initWithGeoJSONGeometry:  invalidGeoJSON], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test initWithWKT

    - (void)testInitWithWKT_WithValidWKT {
        XCTAssertEqualObjects([[[GFBox alloc] initWithWKT: @"BOX(1 1,3 3)"] toWKTString], @"POLYGON((1 1,1 3,3 3,3 1,1 1))");
    }

    - (void)testInitWithWKT_WithInvalidWKT {
        XCTAssertThrows([[GFBox alloc] initWithWKT: @"INVALID()"]);
    }

#pragma mark - Test copy

    - (void) testCopy {
        // NOte a box will always output as a polygon.
        XCTAssertEqualObjects([[[[GFBox alloc] initWithWKT: @"BOX(1 1,3 3)"] copy] toWKTString], @"POLYGON((1 1,1 3,3 3,3 1,1 1))");
    }

#pragma mark - Test toGeoJSONGeometry

    - (void) testToGeoJSONGeometry  {
        XCTAssertEqualObjects([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

#pragma mark - Test description

    - (void) testDescription_NotNil {
        XCTAssertNotNil([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON1] description]);
    }

    - (void) testDescription_WithGeoJSON1 {
        XCTAssertEqualObjects([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON1] description], @"POLYGON((1 1,1 3,3 3,3 1,1 1))");
    }

    - (void) testDescription_WithGeoJSON2 {
        XCTAssertEqualObjects([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON2] description], @"POLYGON((103 2,103 4,110 4,110 2,103 2))");
    }

#pragma mark - Test mapOverlays

    - (void) testMapOverlays {

        NSArray * mapOverlays = [[[GFBox alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];

        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);

        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKPolygon class]]);

        MKPolygon * polygon = (MKPolygon *) [mapOverlays lastObject];

        XCTAssertTrue   ([polygon pointCount] == 5);
        XCTAssertTrue   ([[polygon interiorPolygons] count] == 0);
    }

@end

