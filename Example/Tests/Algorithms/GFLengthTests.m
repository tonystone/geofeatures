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


    - (void) testPoint {
        LengthTest(GFPoint, @"POINT(0 0)", 0.0);
        LengthTest(GFPoint, @"POINT(1 1)", 0.0);
        LengthTest(GFPoint, @"POINT EMPTY", 0.0);
    }

    - (void) testMultiPoint {
        LengthTest(GFMultiPoint, @"MULTIPOINT(0 0,1 1)", 0.0);
        LengthTest(GFMultiPoint, @"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testLineString {
        LengthTest(GFLineString, @"LINESTRING(0 0,1 1)", 1.4142135623730951);
        LengthTest(GFLineString, @"LINESTRING EMPTY", 0.0);
    }

    - (void) testMultiLineString {
        LengthTest(GFMultiLineString, @"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 3.4142135623730949);
        LengthTest(GFMultiLineString, @"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testPolygon {
        LengthTest(GFPolygon, @"POLYGON((0 0,1 1,1 0))", 0.0);
        LengthTest(GFPolygon, @"POLYGON EMPTY", 0.0);
    }

    - (void) testMultiPolygon {
        LengthTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,1 1,1 0)),((0 0,1 1,1 0)))", 0.0);
        LengthTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,1 1,1 0)),((0 0,1 1,1 0)))", 0.0);
        LengthTest(GFMultiPolygon, @"MULTIPOLYGON EMPTY", 0.0);
    }

    - (void) testRing {
        LengthTest(GFRing, @"LINESTRING(0 0,1 1,1 0,0 0)", 0.0);
        LengthTest(GFRing, @"LINESTRING EMPTY", 0.0);
    }

@end