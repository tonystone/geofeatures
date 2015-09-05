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


    - (void) testPoint {
        AreaTest(GFPoint, @"POINT(0 0)", 0.0);
        AreaTest(GFPoint, @"POINT(1 1)", 0.0);
        AreaTest(GFPoint, @"POINT EMPTY", 0.0);
    }

    - (void) testMultiPoint {
        AreaTest(GFMultiPoint, @"MULTIPOINT(0 0,1 1)", 0.0);
        AreaTest(GFMultiPoint, @"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testLineString {
        AreaTest(GFLineString, @"LINESTRING(0 0,1 1)", 0.0);
        AreaTest(GFLineString, @"LINESTRING EMPTY", 0.0);
    }

    - (void) testMultiLineString {
        AreaTest(GFMultiLineString, @"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 0.0);
        AreaTest(GFMultiLineString, @"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testPolygon {
        AreaTest(GFPolygon, @"POLYGON((0 0,0 7,4 2,2 0,0 0))", 16);
        AreaTest(GFPolygon, @"POLYGON EMPTY", 0.0);
    }

@end