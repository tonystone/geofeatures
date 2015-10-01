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

    - (void) testToWKTString_WithPoint {
        WKTTest (GFPoint, @"POINT(1 1)");
    }

    // TODO:  Isn't an empty point POINT()?
    - (void) testToWKTString_WithEmptyPoint1 {
        WKTTest2(GFPoint, @"POINT()", @"POINT(0 0)");
    }

    // TODO:  Isn't an empty point POINT()?
    - (void) testToWKTString_WithEmptyPoint2 {
        WKTTest2(GFPoint, @"POINT EMPTY", @"POINT(0 0)");
    }

    - (void) testToWKTString_WithMultiPoint {
        WKTTest (GFMultiPoint, @"MULTIPOINT((1 1),(2 2))");
    }

    - (void) testToWKTString_WithEmptyMultiPoint1 {
        WKTTest (GFMultiPoint, @"MULTIPOINT()");
    }

    - (void) testToWKTString_WithEmptyMultiPoint2 {
        WKTTest2(GFMultiPoint, @"MULTIPOINT EMPTY", @"MULTIPOINT()");
    }

    - (void) testToWKTString_WithLineString {
        WKTTest (GFLineString, @"LINESTRING(40 60,120 110)");
    }

    - (void) testToWKTString_WithEmptyLineString1 {
        WKTTest (GFLineString, @"LINESTRING()");
    }

    - (void) testToWKTString_WithEmptyLineString2 {
        WKTTest2(GFLineString, @"LINESTRING EMPTY", @"LINESTRING()");
    }

    - (void) testToWKTString_WithMultiLineString {
        WKTTest (GFMultiLineString, @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))");
    }

    - (void) testToWKTString_WithEmptyMultiLineString1 {
        WKTTest (GFMultiLineString, @"MULTILINESTRING()");
    }

    - (void) testToWKTString_WithEmptyMultiLineString2 {
        WKTTest2(GFMultiLineString, @"MULTILINESTRING EMPTY", @"MULTILINESTRING()");
    }

    - (void) testToWKTString_WithPolygon {
        WKTTest (GFPolygon, @"POLYGON((0 0,0 90,90 90,90 0,0 0))");
    }

    - (void) testToWKTString_WithEmptyPolygon1 {
        WKTTest2(GFPolygon, @"POLYGON()", @"POLYGON(())");
    }

    - (void) testToWKTString_WithEmptyPolygon2 {
        WKTTest2(GFPolygon, @"POLYGON EMPTY", @"POLYGON(())");
    }

    - (void) testToWKTString_WithMultiPolygon {
        WKTTest (GFMultiPolygon, @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testToWKTString_WithEmptyMultiPolygon1 {
        WKTTest (GFMultiPolygon, @"MULTIPOLYGON()");
    }

    - (void) testToWKTString_WithEmptyMultiPolygon2 {
        WKTTest2(GFMultiPolygon, @"MULTIPOLYGON EMPTY", @"MULTIPOLYGON()");
    }

    - (void) testToWKTString_WithGeometryCollection {
        WKTTest(GFGeometryCollection, @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }

    - (void) testToWKTString_WithEmptyGeometryCollection1 {
        WKTTest(GFGeometryCollection, @"GEOMETRYCOLLECTION()");
    }

    - (void) testToWKTString_WithEmptyGeometryCollection2 {
        WKTTest2(GFGeometryCollection, @"GEOMETRYCOLLECTION EMPTY", @"GEOMETRYCOLLECTION()");
    }

    - (void) testToWKTString_WithRing {
        WKTTest (GFRing, @"LINESTRING(40 60,120 110)");
    }

    - (void) testToWKTString_WithEmptyRing1 {
        WKTTest (GFRing, @"LINESTRING()");
    }

    - (void) testToWKTString_WithEmptyRing2 {
        WKTTest2(GFRing, @"LINESTRING EMPTY", @"LINESTRING()");
    }

@end

