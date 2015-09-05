/*
*   GFUnionTests.m
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

@interface GFUnionTests : XCTestCase
@end

#define UnionTest(T1,input1,T2, input2,expected) XCTAssertEqualObjects([[[[T1 alloc] initWithWKT: (input1)] union_: [[T2 alloc] initWithWKT: (input2)]] toWKTString], (expected))

@implementation GFUnionTests

    - (void) testPoint {
        UnionTest(GFPoint, @"POINT(1 1)", GFPoint, @"POINT(2 2)", @"MULTIPOINT((1 1),(2 2))");
        UnionTest(GFPoint, @"POINT(40 60)", GFMultiPoint, @"MULTIPOINT((40 60),(40 60))", @"MULTIPOINT((40 60))");
    }

    - (void) testPolygon {
        UnionTest(GFPolygon, @"POLYGON((0 0,0 90,90 90,90 0,0 0))", \
                  GFPolygon, @"POLYGON((120 0,120 90,210 90,210 0,120 0))", \
                             @"MULTIPOLYGON(((0 0,0 90,90 90,90 0,0 0)),((120 0,120 90,210 90,210 0,120 0)))");
        
        UnionTest(GFPolygon, @"POLYGON((120 0,120 90,210 90,210 0,120 0))", \
                  GFPolygon, @"POLYGON((120 0,120 90,210 90,210 0,120 0))", \
                             @"POLYGON((120 90,210 90,210 0,120 0,120 90))");
    }

    - (void) testMultiPolygon {
        UnionTest(GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 90,90 90,90 0,0 0)))", \
                  GFMultiPolygon, @"MULTIPOLYGON(((120 0,120 90,210 90,210 0,120 0)))", \
                                  @"MULTIPOLYGON(((0 0,0 90,90 90,90 0,0 0)),((120 0,120 90,210 90,210 0,120 0)))");
    }


@end