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
    geoJSON1       = @{@"type": @"Box", @"coordinates": @[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]]};
    geoJSON2       = @{@"type": @"Box", @"coordinates": @[@[@(103.0), @(2.0)],@[@(110.0), @(4.0)]]};
    invalidGeoJSON = @{@"type": @"Box", @"coordinates": @{}};
}

@implementation GFBoxTests

    - (void)testConstruction {

        XCTAssertNoThrow([[GFBox alloc] init]);
        XCTAssertNotNil([[GFBox alloc] init]);

        XCTAssertNoThrow([[GFBox alloc] initWithMinCorner: [[GFPoint alloc] initWithX:100.0 y: 0.0] maxCorner: [[GFPoint alloc] initWithX: 101.0 y:1.0]]);
        XCTAssertNotNil([[GFBox alloc] initWithMinCorner: [[GFPoint alloc] initWithX:100.0 y: 0.0] maxCorner: [[GFPoint alloc] initWithX: 101.0 y:1.0]]);
        
        XCTAssertNoThrow([[GFBox alloc] initWithGeoJSONGeometry: geoJSON1]);
        XCTAssertNotNil([[GFBox alloc] initWithGeoJSONGeometry: geoJSON1]);
    }

    - (void)testFailedConstruction {
        XCTAssertThrowsSpecificNamed([[GFBox alloc] initWithGeoJSONGeometry:  invalidGeoJSON], NSException, NSInvalidArgumentException);
        XCTAssertThrows([[GFBox alloc] initWithWKT: @"INVALID()"]);
    }

    - (void) testToGeoJSONGeometry  {
        XCTAssertEqualObjects([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

    - (void) testDescription {

        // Currently we only check if it returns something and its not nill

        XCTAssertNotNil([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON1] description]);
        XCTAssertNotNil([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON2] description]);

        XCTAssertEqualObjects([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON1] description], @"POLYGON((100 0,100 1,101 1,101 0,100 0))");
        XCTAssertEqualObjects([[[GFBox alloc] initWithGeoJSONGeometry: geoJSON2] description], @"POLYGON((103 2,103 4,110 4,110 2,103 2))");
    }

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

