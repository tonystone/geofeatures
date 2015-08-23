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

#define PerimeterTest(input,expected) XCTAssertEqual([[GFGeometry geometryWithWKT: (input)] perimeter], (expected))

@implementation GFPerimeterTests

    - (void) testPoint {
        PerimeterTest(@"POINT(0 0)", 0.0);
        PerimeterTest(@"POINT(1 1)", 0.0);
        PerimeterTest(@"POINT EMPTY", 0.0);
    }

    - (void) testMultiPoint {
        PerimeterTest(@"MULTIPOINT(0 0,1 1)", 0.0);
        PerimeterTest(@"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testLineString {
        PerimeterTest(@"LINESTRING(0 0,1 1)", 0.0);
        PerimeterTest(@"LINESTRING EMPTY", 0.0);
    }

    - (void) testMultiLineString {
        PerimeterTest(@"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 0.0);
        PerimeterTest(@"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testPolygon {
        PerimeterTest(@"POLYGON((0 0,0 4,4 4,4 0,0 0),(1 1,2 1,2 2,1 2,1 1))", 20);
        PerimeterTest(@"POLYGON EMPTY", 0.0);
    }

    - (void) testMultiPolygon {
        PerimeterTest(@"MULTIPOLYGON(((0 0,0 1,1 0,0 0)))", 1.0 + 1.0 + sqrt(2.0));
        PerimeterTest(@"MULTIPOLYGON EMPTY", 0.0);
    }


@end