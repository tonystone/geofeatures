/*
*   GFMultiLineStringTests.m
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
    geoJSON1       = @{@"type": @"MultiLineString", @"coordinates": @[@[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]], @[@[@(102.0), @(2.0)],@[@(103.0), @(3.0)]]]};
    geoJSON2       = @{@"type": @"MultiLineString", @"coordinates": @[@[@[@(103.0), @(2.0)],@[@(101.0), @(1.0)]], @[@[@(102.0), @(2.0)],@[@(103.0), @(3.0)]]]};
    invalidGeoJSON = @{@"type": @"MultiLineString", @"coordinates": @{}};
}

@interface GFMultiLineStringTests : XCTestCase
@end

@implementation GFMultiLineStringTests

    - (void)testConstruction {

        XCTAssertNoThrow([[GFMultiLineString alloc] init]);
        XCTAssertNotNil([[GFMultiLineString alloc] init]);
    }

    - (void)testFailedConstruction {
        XCTAssertThrowsSpecificNamed([[GFMultiLineString alloc] initWithGeoJSONGeometry: invalidGeoJSON], NSException, @"Invalid GeoJSON");
    }

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFMultiLineString alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

    - (void) testDescription {
        XCTAssertEqualObjects([[[GFMultiLineString alloc] initWithGeoJSONGeometry: geoJSON1] description], @"MULTILINESTRING((100 0,101 1),(102 2,103 3))");
        XCTAssertEqualObjects([[[GFMultiLineString alloc] initWithGeoJSONGeometry: geoJSON2] description], @"MULTILINESTRING((103 2,101 1),(102 2,103 3))");
    }

    - (void) testMapOverlays {
        
        NSArray * mapOverlays = [[[GFMultiLineString alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 2);
        
        for (int i = 0; i < [mapOverlays count]; i++) {
            id mapOverlay = mapOverlays[i];
            
            XCTAssertTrue   ([mapOverlay isKindOfClass: [MKPolyline class]]);
            
            MKPolyline * polyline = mapOverlay;
            
            XCTAssertTrue   ([polyline pointCount] == 2);
        }
    }

    - (void) testObjectAtIndexedSubscript {

        GFMultiLineString * multiLineString = [[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0))"];

        XCTAssertNoThrow(multiLineString[0]);
        XCTAssertNoThrow(multiLineString[1]);
        XCTAssertThrowsSpecificNamed(multiLineString[2], NSException, NSRangeException);

        XCTAssertEqualObjects([multiLineString[0] toWKTString], @"LINESTRING(0 0,5 0)");
        XCTAssertEqualObjects([multiLineString[1] toWKTString], @"LINESTRING(5 0,10 0,5 -5,5 0)");
    }


@end