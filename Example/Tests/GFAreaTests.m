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
#import "GFGeometryTests.h"
#import <MapKit/MapKit.h>
#import <XCTest/XCTest.h>

@interface GFAreaTests : XCTestCase
@end

#define AreaTest(input,expected) XCTAssertEqual([[GFGeometry geometryWithWKT: (input)] area], (expected))

@implementation GFAreaTests


    - (void) testPoint {
        AreaTest(@"POINT(0 0)", 0.0);
        AreaTest(@"POINT(1 1)", 0.0);
        AreaTest(@"POINT EMPTY", 0.0);
    }

    - (void) testMultiPoint {
        AreaTest(@"MULTIPOINT(0 0,1 1)", 0.0);
        AreaTest(@"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testLineString {
        AreaTest(@"LINESTRING(0 0,1 1)", 0.0);
        AreaTest(@"LINESTRING EMPTY", 0.0);
    }

    - (void) testMultiLineString {
        AreaTest(@"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 0.0);
        AreaTest(@"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testPolygon {
        AreaTest(@"POLYGON((0 0,0 7,4 2,2 0,0 0))", 16);
        AreaTest(@"POLYGON EMPTY", 0.0);
    }


@end