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

    - (void)testConstruction {

        XCTAssertNoThrow([[GFLineString alloc] init]);
        XCTAssertNotNil([[GFLineString alloc] init]);
    }

    - (void)testFailedConstruction {
        XCTAssertThrowsSpecificNamed([[GFLineString alloc] initWithGeoJSONGeometry: invalidGeoJSON], NSException, @"Invalid GeoJSON");
    }

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFLineString alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

    - (void) testDescription {
        XCTAssertEqualObjects([[[GFLineString alloc] initWithGeoJSONGeometry: geoJSON1] description], @"LINESTRING(100 0,101 1)");
        XCTAssertEqualObjects([[[GFLineString alloc] initWithGeoJSONGeometry: geoJSON2] description], @"LINESTRING(102 0,102 1)");
    }

    - (void) testMapOverlays {
    
        NSArray * mapOverlays = [[[GFLineString alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);
        
        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKPolyline class]]);
        
        MKPolyline * polyline = (MKPolyline *) [mapOverlays lastObject];
        
        XCTAssertTrue   ([polyline pointCount] == 2);
    }

@end

