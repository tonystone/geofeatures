/*
*   GFWithinTests.m
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

@interface GFWithinTests : XCTestCase
@end

#define WithinTest(input1,input2,expected) XCTAssertEqual([[GFGeometry geometryWithWKT: (input1)] within: [GFGeometry geometryWithWKT: (input2)]], (expected))

@implementation GFWithinTests

    - (void) testPoint {
        WithinTest(@"POINT(4 1)", @"POINT(4 1)", true);
        WithinTest(@"POINT(0 0)", @"POINT(4 1)", false);
    }


    - (void) testLineString {
        WithinTest(@"POINT(0.5 0.5)", @"LINESTRING(0 0,1 1)", true);
        WithinTest(@"POINT(2 2)", @"LINESTRING(0 0,1 1)", false);
    }

    - (void) testPolygon {
        WithinTest(@"POINT(4 1)", @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                   "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", true);
        
        WithinTest(@"LINESTRING(4 1,4 2)", @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                   "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", true);
        
        WithinTest(@"LINESTRING(0 0,1 1)", @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                   "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", false);
        
    }


@end