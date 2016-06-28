/*
*   GFLengthTests.m
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

@interface GFLengthTests : XCTestCase
@end

#define LengthTest(T, input,expected) XCTAssertEqual([[[T alloc] initWithWKT: (input)] length], (expected))

@implementation GFLengthTests


    - (void) testLength_WithValidPoint1 {
        LengthTest(GFPoint, @"POINT(0 0)", 0.0);
    }

    - (void) testLength_WithValidPoint2 {
        LengthTest(GFPoint, @"POINT(1 1)", 0.0);
    }

    - (void) testLength_WithEmptyPoint {
        LengthTest(GFPoint, @"POINT EMPTY", 0.0);
    }

    - (void) testLength_WithValidMultiPoint {
        LengthTest(GFMultiPoint, @"MULTIPOINT(0 0,1 1)", 0.0);
    }

    - (void) testLength_WithEmptyMultiPoint {
        LengthTest(GFMultiPoint, @"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testLength_WithValidLineString {
        LengthTest(GFLineString, @"LINESTRING(0 0,1 1)", 1.4142135623730951);
    }

    - (void) testLength_WithValidLineString2 {
        LengthTest(GFLineString, @"LINESTRING(0 0,0 2)", 2.0);
    }

    - (void) testLength_WithEmptyLineString {
        LengthTest(GFLineString, @"LINESTRING EMPTY", 0.0);
    }

    - (void) testLength_WithValidMultiLineString {
        LengthTest(GFMultiLineString, @"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 3.4142135623730949);
    }

    - (void) testLength_WithEmptyMultiLineString {
        LengthTest(GFMultiLineString, @"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testLength_WithValidPolygon {
        LengthTest(GFPolygon, @"POLYGON((0 0,1 1,1 0))", 0.0);
    }

    - (void) testLength_WithEmptyPolygon {
        LengthTest(GFPolygon, @"POLYGON EMPTY", 0.0);
    }

    - (void) testLength_WithValidMultiPolygon1 {
        LengthTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,1 1,1 0)),((0 0,1 1,1 0)))", 0.0);
    }

    - (void) testLength_WithValidMultiPolygon2 {
        LengthTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,1 1,1 0)),((0 0,1 1,1 0)))", 0.0);
    }

    - (void) testLength_WithEmptyMultiPolygon {
        LengthTest(GFMultiPolygon, @"MULTIPOLYGON EMPTY", 0.0);
    }

    - (void) testLength_WithValidRing {
        LengthTest(GFRing, @"LINESTRING(0 0,1 1,1 0,0 0)", 0.0);
    }

    - (void) testLength_WithEmptyRing {
        LengthTest(GFRing, @"LINESTRING EMPTY", 0.0);
    }

    - (void) testLength_WithGoemetryCollection_LineString {
        LengthTest(GFGeometryCollection, @"GEOMETRYCOLLECTION(LINESTRING(0 0,0 2))", 2.0);
    }

    - (void) testLengthPerformance {
        GFLineString * lineString = [[GFLineString alloc] initWithWKT: @"LINESTRING (0 0, 0 2, 0 3, 0 4, 0 5)"];
    
        [self measureBlock:^{
            
            for (int i = 1; i <= 500000; i++) {
                (void) [lineString length];
            }
        }];
    }

@end