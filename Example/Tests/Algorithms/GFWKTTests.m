/*
*   GFWKTTests.m
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
*   Created by Tony Stone on 06/15/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFWKTTests : XCTestCase
@end

#define WKTTest(T,wkt) XCTAssertEqualObjects([[[T alloc] initWithWKT: (wkt)] toWKTString], [(wkt) uppercaseString])
#define WKTTest2(T, wkt,expectedWKT) XCTAssertEqualObjects([[[T alloc] initWithWKT: (wkt)] toWKTString], [(expectedWKT) uppercaseString])

@implementation GFWKTTests

    - (void) testPoint {
        WKTTest (GFPoint, @"POINT(1 1)");
        WKTTest2(GFPoint, @"POINT()", @"POINT(0 0)");
        WKTTest2(GFPoint, @"POINT EMPTY", @"POINT(0 0)");
    }

    - (void) testMultiPoint {
        WKTTest (GFMultiPoint, @"MULTIPOINT((1 1),(2 2))");
        WKTTest (GFMultiPoint, @"MULTIPOINT()");
        WKTTest2(GFMultiPoint, @"MULTIPOINT EMPTY", @"MULTIPOINT()");
    }

    - (void) testLineString {
        WKTTest (GFLineString, @"LINESTRING(40 60,120 110)");
        WKTTest (GFLineString, @"LINESTRING()");
        WKTTest2(GFLineString, @"LINESTRING EMPTY", @"LINESTRING()");
    }

    - (void) testMultiLineString {
        WKTTest (GFMultiLineString, @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))");
        WKTTest (GFMultiLineString, @"MULTILINESTRING()");
        WKTTest2(GFMultiLineString, @"MULTILINESTRING EMPTY", @"MULTILINESTRING()");
    }

    - (void) testPolygon {
        WKTTest (GFPolygon, @"POLYGON((0 0,0 90,90 90,90 0,0 0))");
        WKTTest2(GFPolygon, @"POLYGON()", @"POLYGON(())");
        WKTTest2(GFPolygon, @"POLYGON EMPTY", @"POLYGON(())");
    }

    - (void) testMultiPolygon {
        WKTTest (GFMultiPolygon, @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
        WKTTest (GFMultiPolygon, @"MULTIPOLYGON()");
        WKTTest2(GFMultiPolygon, @"MULTIPOLYGON EMPTY", @"MULTIPOLYGON()");
    }

    - (void) testGeometryCollection {
        WKTTest(GFGeometryCollection, @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
        WKTTest(GFGeometryCollection, @"GEOMETRYCOLLECTION()");
        WKTTest2(GFGeometryCollection, @"GEOMETRYCOLLECTION EMPTY", @"GEOMETRYCOLLECTION()");
    }

@end