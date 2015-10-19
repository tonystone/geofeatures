/*
*   GFAreaTests.m
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

@interface GFAreaTests : XCTestCase
@end

#define AreaTest(T, input,expected) XCTAssertEqual([[[T alloc] initWithWKT: (input)] area], (expected))

@implementation GFAreaTests


    - (void) testArea_WithPoint0 {
        AreaTest(GFPoint, @"POINT(0 0)", 0.0);
    }

    - (void) testArea_WithPoint1 {
        AreaTest(GFPoint, @"POINT(1 1)", 0.0);
    }

    - (void) testArea_WithEmptyPoint {
        AreaTest(GFPoint, @"POINT EMPTY", 0.0);
    }

    - (void) testArea_WithSimpleMultiPoint {
        AreaTest(GFMultiPoint, @"MULTIPOINT(0 0,1 1)", 0.0);
    }

    - (void) testArea_WithEmptyMultiPoint {
        AreaTest(GFMultiPoint, @"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testArea_WithSimpleLineString {
        AreaTest(GFLineString, @"LINESTRING(0 0,1 1)", 0.0);
    }
    - (void) testArea_WithEmtptyLineString {
        AreaTest(GFLineString, @"LINESTRING EMPTY", 0.0);
    }

    - (void) testArea_WithSimpleMultiLineString {
        AreaTest(GFMultiLineString, @"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 0.0);
    }

    - (void) testArea_WithEmptyMultiLineString {
        AreaTest(GFMultiLineString, @"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testArea_WithSimplePolygon {
        AreaTest(GFPolygon, @"POLYGON((0 0,0 7,4 2,2 0,0 0))", 16);
    }

    - (void) testArea_WithEmptyPolygon {
        AreaTest(GFPolygon, @"POLYGON EMPTY", 0.0);
    }

    - (void) testArea_WithMultiPolygon {
        AreaTest(GFMultiPolygon , @"MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((10 10,10 17,14 12,12 10,10 10)))", 32);
    }

    - (void) testArea_WithMultiPolygon_Intersecting {
        AreaTest(GFMultiPolygon , @"MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((0 0,0 7,4 2,2 0,0 0)))", 32);
    }

    - (void) testArea_WithSimpleRing {
        AreaTest(GFRing, @"LINESTRING(0 0,0 7,4 2,2 0,0 0)", 16);
    }

    - (void) testArea_WithEmptying {
        AreaTest(GFRing, @"LINESTRING EMPTY", 0.0);
    }

    - (void) testArea_WithGeometryCollection_Polygon {
        AreaTest(GFGeometryCollection , @"GEOMETRYCOLLECTION(POLYGON((0 0,0 7,4 2,2 0,0 0)),POLYGON((10 10,10 17,14 12,12 10,10 10)))", 32);
    }

    - (void) testArea_WithGeometryCollection_Polygon_Intersecting {
        AreaTest(GFGeometryCollection , @"GEOMETRYCOLLECTION(POLYGON((0 0,0 7,4 2,2 0,0 0)),POLYGON((0 0,0 7,4 2,2 0,0 0)))", 32);
    }

    - (void) testArea_WithGeometryCollection_Ring {
        XCTAssertEqual([[[GFGeometryCollection alloc] initWithArray: @[
                                                                       [[GFRing alloc] initWithWKT:@"LINESTRING(0 0,0 7,4 2,2 0,0 0)"]
                                                                       ] ] area],  16);
    }

    - (void) testArea_WithGeometryCollection_Ring_Polygon {
        XCTAssertEqual(([[[GFGeometryCollection alloc] initWithArray: @[
                                                                   [[GFRing alloc] initWithWKT:@"LINESTRING(0 0,0 7,4 2,2 0,0 0)"],
                                                                   [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0,0 7,4 2,2 0,0 0))"]
                                                                   ]] area]),  32);
    }

@end