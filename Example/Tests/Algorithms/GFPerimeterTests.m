/*
*   GFPerimeterTests.m
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

@interface GFPerimeterTests : XCTestCase
@end

#define PerimeterTest(T,input,expected) XCTAssertEqual([[[T alloc] initWithWKT: (input)] perimeter], (expected))

@implementation GFPerimeterTests

    - (void) testPerimeter_WithValidPoint1 {
        PerimeterTest(GFPoint, @"POINT(0 0)", 0.0);
    }

    - (void) testPerimeter_WithValidPoint2 {
        PerimeterTest(GFPoint, @"POINT(1 1)", 0.0);
    }

    - (void) testPerimeter_WithEmptyPoint {
        PerimeterTest(GFPoint, @"POINT EMPTY", 0.0);
    }

    - (void) testPerimeter_WithValidMultiPoint {
        PerimeterTest(GFMultiPoint, @"MULTIPOINT(0 0,1 1)", 0.0);
    }

    - (void) testPerimeter_WithEmptyMultiPoint {
        PerimeterTest(GFMultiPoint, @"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testPerimeter_WithValidLineString {
        PerimeterTest(GFLineString, @"LINESTRING(0 0,1 1)", 0.0);
    }

    - (void) testPerimeter_WithEmptyLineString {
        PerimeterTest(GFLineString, @"LINESTRING EMPTY", 0.0);
    }

    - (void) testPerimeter_WithValidMultiLineString {
        PerimeterTest(GFMultiLineString, @"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 0.0);
    }

    - (void) testPerimeter_WithEmptyMultiLineString {
        PerimeterTest(GFMultiLineString, @"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testPerimeter_WithValidPolygon {
        PerimeterTest(GFPolygon, @"POLYGON((0 0,0 4,4 4,4 0,0 0),(1 1,2 1,2 2,1 2,1 1))", 20);
    }

    - (void) testPerimeter_WithEmptyPolygon {
        PerimeterTest(GFPolygon, @"POLYGON EMPTY", 0.0);
    }

    - (void) testPerimeter_WithValidMultiPolygon {
        PerimeterTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 1,1 0,0 0)))", 1.0 + 1.0 + sqrt(2.0));
    }

    - (void) testPerimeter_WithEmptyMultiPolygon {
        PerimeterTest(GFMultiPolygon, @"MULTIPOLYGON EMPTY", 0.0);
    }

    - (void) testPerimeter_WithValidRing {
        PerimeterTest(GFRing, @"LINESTRING(0 0,0 1,1 1,1 0,0 0)", 4);
    }

    - (void) testPerimeter_WithEmptyRing {
        PerimeterTest(GFRing, @"LINESTRING EMPTY", 0.0);
    }

@end