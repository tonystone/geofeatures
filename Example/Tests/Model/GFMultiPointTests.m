/*
*   GFMultiPointTests.m
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
    geoJSON1       = @{@"type": @"MultiPoint", @"coordinates": @[@[@(100.0), @(0.0)],@[@(101.0), @(1.0)]]};
    geoJSON2       = @{@"type": @"MultiPoint", @"coordinates": @[@[@(103.0), @(2.0)],@[@(101.0), @(1.0)]]};
    invalidGeoJSON = @{@"type": @"MultiPoint", @"coordinates": @{}};
}

@interface GFMultiPointTests : XCTestCase
@end

@implementation GFMultiPointTests

    - (void)testConstruction {

        XCTAssertNoThrow([[GFMultiPoint alloc] init]);
        XCTAssertNotNil([[GFMultiPoint alloc] init]);
    }

    - (void)testFailedConstruction {
        XCTAssertThrowsSpecificNamed([[GFMultiPoint alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
        XCTAssertThrows([[GFMultiPoint alloc] initWithWKT: @"INVALID()"]);
    }

    - (void) testToGeoJSONGeometry {
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithGeoJSONGeometry: geoJSON1] toGeoJSONGeometry], geoJSON1);
    }

    - (void) testDescription {
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithGeoJSONGeometry: geoJSON1] description], @"MULTIPOINT((100 0),(101 1))");
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithGeoJSONGeometry: geoJSON2] description], @"MULTIPOINT((103 2),(101 1))");
    }

    - (void) testMapOverlays {
        
        NSArray * mapOverlays = [[[GFMultiPoint alloc] initWithGeoJSONGeometry: geoJSON1] mkMapOverlays];
        
        XCTAssertNotNil (mapOverlays);
        XCTAssertTrue   ([mapOverlays count] == 2);
        
        for (int i = 0; i < [mapOverlays count]; i++) {
            id mapOverlay = mapOverlays[i];
            
            XCTAssertTrue   ([mapOverlay isKindOfClass: [MKCircle class]]);
            
            MKCircle * circle = mapOverlay;
            
            XCTAssertTrue   ([circle coordinate].longitude == 100.0 + i);
            XCTAssertTrue   ([circle coordinate].latitude == 0.0 + i);
        }
    }

#pragma mark - Querying Tests

    - (void) testCount {

        XCTAssertEqual([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] count], 0);
        XCTAssertEqual([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1))"] count], 1);
        XCTAssertEqual([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] count], 2);
    }

    - (void) testObjectAtIndex {

        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] geometryAtIndex: 0] toWKTString], @"POINT(1 1)");
        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] geometryAtIndex: 1] toWKTString], @"POINT(2 2)");

        XCTAssertThrowsSpecificNamed(([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1))"] geometryAtIndex: 1]), NSException, NSRangeException);
    }

    - (void) testFirstObject {

        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] firstGeometry] toWKTString], @"POINT(1 1)");
        
        XCTAssertNoThrow([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] firstGeometry]);
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] firstGeometry], nil);
    }

    - (void) testLastObject {

        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"] lastGeometry] toWKTString], @"POINT(2 2)");
        
        XCTAssertNoThrow([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] lastGeometry]);
        XCTAssertEqualObjects([[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT()"] lastGeometry], nil);
    }

#pragma mark - Indexed Subscripting Tests

    - (void) testObjectAtIndexedSubscript {

        GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"];

        XCTAssertNoThrow(multiPoint[0]);
        XCTAssertNoThrow(multiPoint[1]);
        XCTAssertThrowsSpecificNamed(multiPoint[2], NSException, NSRangeException);
        
        XCTAssertEqualObjects([multiPoint[0] toWKTString], @"POINT(1 1)");
        XCTAssertEqualObjects([multiPoint[1] toWKTString], @"POINT(2 2)");
    }

@end


