/*
*   GFIsValidTests.m
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

@interface GFIsValidTests : XCTestCase
@end

#define IsValidTest(T, input,expected) XCTAssertEqual([[[T alloc] initWithWKT: (input)] isValid], (expected))

@implementation GFIsValidTests


    - (void) testIsValid_WithValidPoint0 {
        IsValidTest(GFPoint, @"POINT(0 0)", true);
    }

    - (void) testIsValid_WithValidPoint1 {
        IsValidTest(GFPoint, @"POINT(1 1)", true);
    }

    - (void) testIsValid_WithEmptyPoint {
        IsValidTest(GFPoint, @"POINT EMPTY", true);
    }

    - (void) testIsValid_WithValidMultiPoint {
        IsValidTest(GFMultiPoint, @"MULTIPOINT(0 0,1 1)", true);
    }

    - (void) testIsValid_WithEmptyMultiPoint {
        IsValidTest(GFMultiPoint, @"MULTIPOINT EMPTY", true);
    }

    - (void) testIsValid_WithValidLineString {
        IsValidTest(GFLineString, @"LINESTRING(0 0,1 1)", true);
    }

    - (void) testIsValid_WithEmptyLineString {
        IsValidTest(GFLineString, @"LINESTRING EMPTY", false);
    }

    - (void) testIsValid_WithValidMultiLineString {
        IsValidTest(GFMultiLineString, @"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", true);
    }

    - (void) testIsValid_WithEmptyMultiLineString {
        IsValidTest(GFMultiLineString, @"MULTILINESTRING EMPTY", true);
    }

    - (void) testIsValid_WithValidPolygon {
        IsValidTest(GFPolygon, @"POLYGON((0 0,0 7,4 2,2 0,0 0))", true);
    }

    - (void) testIsValid_WithEmptyPolygon {
        IsValidTest(GFPolygon, @"POLYGON EMPTY", false);
    }

    - (void) testIsValid_WithValidMultiPolygon {
        IsValidTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((10 10,10 17,14 12,12 10,10 10)))", true);
    }

    - (void) testIsValid_WithInvalidMultiPolygon {
        IsValidTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((0 0,0 7,4 2,2 0,0 0)))", false);
    }

    - (void) testIsValid_WithEmptyMultiPolygon {
        IsValidTest(GFMultiPolygon, @"MULTIPOLYGON EMPTY", true);
    }

    - (void) testValid_WithRing {
        IsValidTest(GFRing, @"LINESTRING(0 0,0 7,4 2,2 0,0 0)", true);
    }

    - (void) testIsValid_WithEmptyRing {
        IsValidTest(GFRing, @"LINESTRING EMPTY", false);
    }

@end