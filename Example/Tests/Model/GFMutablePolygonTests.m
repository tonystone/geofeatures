/*
*   GFMutablePolygonTests.m
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
*   Created by Tony Stone on 09/25/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFMutablePolygonTests : XCTestCase
@end

@implementation GFMutablePolygonTests

    - (void) testMutableCopy_IsMemberOfClass {
        XCTAssertTrue([[[[GFPolygon alloc] initWithWKT: @"POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))"] mutableCopy] isMemberOfClass: [GFMutablePolygon class]]);
    }

    - (void) testMutableCopy_IsCorrectValue {
        XCTAssertEqualObjects([[[[GFPolygon alloc] initWithWKT: @"POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))"] mutableCopy] toWKTString], @"POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2))");
    }

    - (void) testSetOuterRing_WithValidRing {
        GFMutablePolygon * polygon = [[GFMutablePolygon alloc] init];

        [polygon setOuterRing: [[GFRing alloc] initWithWKT: @"LINESTRING(100 0,200 100,200 0,100 1,100 0)"]];

        XCTAssertEqualObjects([polygon toWKTString], @"POLYGON((100 0,200 100,200 0,100 1,100 0))");
    }

    - (void) testSetOuterRing_WithEmptyRing {
        GFMutablePolygon * polygon = [[GFMutablePolygon alloc] init];

        [polygon setOuterRing: [[GFRing alloc] initWithWKT: @"LINESTRING()"]];

        XCTAssertEqualObjects([polygon toWKTString], @"POLYGON(())");
    }

    - (void) testSetOuterRing_WithNilRing {
        GFMutablePolygon * polygon = [[GFMutablePolygon alloc] init];

        XCTAssertThrowsSpecificNamed([polygon setOuterRing: nil], NSException, NSInvalidArgumentException);
    }

    - (void) testInnerRings_WithValidRings {
        GFMutablePolygon * polygon = [[GFMutablePolygon alloc] init];
        GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithArray: @[
                [[GFRing alloc] initWithWKT: @"LINESTRING(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)"]
        ]];

        [polygon setOuterRing: [[GFRing alloc] initWithWKT: @"LINESTRING(100 0,200 100,200 0,100 1,100 0)"]];
        [polygon setInnerRings: geometryCollection];

        XCTAssertEqualObjects([polygon toWKTString], @"POLYGON((100 0,200 100,200 0,100 1,100 0),(100.2 0.2,100.2 0.8,100.8 0.8,100.8 0.2,100.2 0.2))");
    }

    - (void) testInnerRings_WithInvalidRings {
        GFMutablePolygon * polygon = [[GFMutablePolygon alloc] init];
        GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithArray: @[
                [[GFLineString alloc] initWithWKT: @"LINESTRING(100.2 0.2,100.8 0.2,100.8 0.8,100.2 0.8,100.2 0.2)"]
        ]];

        XCTAssertThrowsSpecificNamed([polygon setInnerRings: geometryCollection], NSException, NSInvalidArgumentException);
    }

    - (void) testInnerRings_WithNilRings {
        GFMutablePolygon * polygon = [[GFMutablePolygon alloc] init];

        XCTAssertThrowsSpecificNamed([polygon setInnerRings: nil], NSException, NSInvalidArgumentException);
    }

@end

