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

#define IsValidTest(input,expected) XCTAssertEqual([[GFGeometry geometryWithWKT: (input)] isValid], (expected))

@implementation GFIsValidTests


    - (void) testPoint {
        IsValidTest(@"POINT(0 0)", true);
        IsValidTest(@"POINT(1 1)", true);
        IsValidTest(@"POINT EMPTY", true);
    }

    - (void) testMultiPoint {
        IsValidTest(@"MULTIPOINT(0 0,1 1)", true);
        IsValidTest(@"MULTIPOINT EMPTY", true);
    }

    - (void) testLineString {
        IsValidTest(@"LINESTRING(0 0,1 1)", true);
        IsValidTest(@"LINESTRING EMPTY", false);
    }

    - (void) testMultiLineString {
        IsValidTest(@"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", true);
        IsValidTest(@"MULTILINESTRING EMPTY", true);
    }

    - (void) testPolygon {
        IsValidTest(@"POLYGON((0 0,0 7,4 2,2 0,0 0))", true);
        IsValidTest(@"POLYGON EMPTY", false);
    }


    - (void) testMultiPolygon {
        IsValidTest(@"MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((0 0,0 7,4 2,2 0,0 0)))", false);
        IsValidTest(@"MULTIPOLYGON(((0 0,0 7,4 2,2 0,0 0)),((10 10,10 17,14 12,12 10,10 10)))", true);
        IsValidTest(@"MULTIPOLYGON EMPTY", true);
    }

@end