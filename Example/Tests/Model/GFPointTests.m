/*
*   GFPointTests.m
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
    geoJSON1       = @{@"type": @"Point", @"coordinates": @[@(100.0), @(0.0)]};
    geoJSON2       = @{@"type": @"Point", @"coordinates": @[@(103.0), @(2.0)]};
    invalidGeoJSON = @{@"type": @"Point", @"coordinates": @{}};
}


@interface GFPointTests : XCTestCase
@end

@implementation GFPointTests

#pragma mark - Test init

    - (void)testInit_NoThrow {
        XCTAssertNoThrow([[GFPoint alloc] init]);
    }

    - (void)testInit_NotNil {
        XCTAssertNotNil([[GFPoint alloc] init]);
    }

    - (void) testInit {
        XCTAssertEqualObjects([[[GFPoint alloc] init] toWKTString], @"POINT(0 0)");
    }

#pragma mark - Test initWithGeoJSONGeometry

    - (void) testInitWithGeoJSONGeometry_WithValidGeoJSON {
        XCTAssertEqualObjects([[[GFPoint alloc] initWithGeoJSONGeometry: geoJSON1] toWKTString], @"POINT(100 0)");
    }

    - (void)testInitWithGeoJSONGeometry_WithInvalidGeoJSON {
        XCTAssertThrowsSpecificNamed([[GFPoint alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
    }

#pragma mark - Test initWithWKT

    - (void) testInitWithWKT_WithValidWKT {
        XCTAssertEqualObjects([[[GFPoint alloc] initWithWKT: @"POINT(100 0)"] toWKTString], @"POINT(100 0)");
    }

    - (void) testInitWithWKT_WithEmptyWKT {
        XCTAssertEqualObjects([[[GFPoint alloc] initWithWKT: @"POINT EMPTY"] toWKTString], @"POINT(0 0)");
    }

    - (void)testInitWithWKT_WithInvalidWKT {
        XCTAssertThrows([[GFPoint alloc] initWithWKT: @"INVALID()"]);
    }

#pragma mark - Test initWithXY

    - (void)testInitWithXY_NoThrow {
        XCTAssertNoThrow([[GFPoint alloc] initWithX: 100.0 y:  0.0]);
    }

    - (void)testInitWithXY_NotNil {
        XCTAssertNotNil([[GFPoint alloc] initWithX: 103.0 y:  2.0]);
    }

#pragma mark - Test copy

    - (void) testCopy {
        XCTAssertEqualObjects([[[[GFPoint alloc] initWithWKT: @"POINT(103 2)"] copy] toWKTString], @"POINT(103 2)");
    }

#pragma mark - Test x

    - (void) testX {
        XCTAssertEqual([[[GFPoint alloc] initWithX: 103.0 y:  2.0] x], 103.0);
    }

#pragma mark - Test y

    - (void) testY {
        XCTAssertEqual([[[GFPoint alloc] initWithX: 103.0 y:  2.0] y], 2.0);
    }

#pragma mark - Test toGeoJSONGeometry

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFPoint alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

#pragma mark - Test description

    - (void) testDescription_WithGeoJSON1 {
        XCTAssertEqualObjects([[[GFPoint alloc] initWithGeoJSONGeometry: geoJSON1] description], @"POINT(100 0)");
    }

    - (void) testDescription_WithGeoJSON2 {
        XCTAssertEqualObjects([[[GFPoint alloc] initWithGeoJSONGeometry: geoJSON2] description], @"POINT(103 2)");
    }

#pragma mark - Test mapOverlays

    - (void) testMapOverlays {
    
        NSArray * mapOverlays = [[[GFPoint alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 1);
        
        XCTAssertTrue   ([[mapOverlays lastObject] isKindOfClass: [MKCircle class]]);
        
        MKCircle * circle = (MKCircle *) [mapOverlays lastObject];
        
        XCTAssertTrue   ([circle coordinate].longitude == 100.0);
        XCTAssertTrue   ([circle coordinate].latitude == 0.0);
    }

@end

