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

    - (void)testConstruction {
        XCTAssertNoThrow([[GFRing alloc] init]);
        XCTAssertNotNil([[GFRing alloc] init]);
    }

    - (void)testFailedConstruction {
        XCTAssertThrowsSpecificNamed(([GFGeometry geometryWithGeoJSONGeometry: @{@"type": @"LineString",@"coordinates": @{}}]), NSException, @"Invalid GeoJSON");
        XCTAssertThrows([[GFRing alloc] initWithWKT: @"INVALID()"]);
    }

    - (void) testDescription {

        // Currently we only check if it returns something and its not nill

        XCTAssertNotNil([[[GFRing alloc] initWithGeoJSONGeometry: geoJSON1] description]);
        XCTAssertNotNil([[[GFRing alloc] initWithGeoJSONGeometry: geoJSON2] description]);

        XCTAssertTrue ([[[[GFRing alloc] initWithGeoJSONGeometry: geoJSON1] description] length] > 0);
        XCTAssertTrue ([[[[GFRing alloc] initWithGeoJSONGeometry: geoJSON2] description] length] > 0);
    }

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFRing alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

    - (void) testMapOverlays {
    
        NSArray * mapOverlays = [[[GFRing alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);
        
        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKPolyline class]]);
        
        MKPolyline * polyline = (MKPolyline *) [mapOverlays lastObject];
        
        XCTAssertTrue   ([polyline pointCount] == 2);
    }

#pragma mark - Querying Tests

    - (void) testCount {

        XCTAssertEqual([[[GFRing alloc] initWithWKT: @"LINESTRING()"] count], 0);
        XCTAssertEqual([[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] count], 5);
    }

    - (void) testObjectAtIndex {

        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] pointAtIndex: 0] toWKTString], @"POINT(20 0)");
        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] pointAtIndex: 1] toWKTString], @"POINT(20 10)");

        XCTAssertThrowsSpecificNamed(([[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] pointAtIndex: 5]), NSException, NSRangeException);
    }

    - (void) testFirstObject {

        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] firstPoint] toWKTString], @"POINT(20 0)");

        XCTAssertNoThrow([[[GFRing alloc] initWithWKT: @"LINESTRING()"] firstPoint]);
        XCTAssertEqualObjects([[[GFRing alloc] initWithWKT: @"LINESTRING()"] firstPoint], nil);
    }

    - (void) testLastObject {

        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] lastPoint] toWKTString], @"POINT(20 0)");

        XCTAssertNoThrow([[[GFRing alloc] initWithWKT: @"LINESTRING()"] lastPoint]);
        XCTAssertEqualObjects([[[GFRing alloc] initWithWKT: @"LINESTRING()"] lastPoint], nil);
    }

#pragma mark - Indexed Subscripting Tests

    - (void) testObjectAtIndexedSubscript {

        GFRing * ring = [[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"];

        XCTAssertNoThrow(ring[0]);
        XCTAssertNoThrow(ring[1]);
        XCTAssertThrowsSpecificNamed(ring[5], NSException, NSRangeException);

        XCTAssertEqualObjects([ring[0] toWKTString], @"POINT(20 0)");
        XCTAssertEqualObjects([ring[1] toWKTString], @"POINT(20 10)");
    }

@end

