/*
*   GFMutableLineStringTests.m
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
*   Created by Tony Stone on 09/23/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFMutableLineStringTests : XCTestCase
@end

@implementation GFMutableLineStringTests

    - (void) testMutableCopy_IsCorrectClass {
        XCTAssertTrue([[[[GFLineString alloc] initWithWKT: @"LINESTRING(100 0,101 1)"] mutableCopy] isMemberOfClass: [GFMutableLineString class]]);
    }

    - (void) testMutableCopy_IsCorrectValue {
        XCTAssertEqualObjects([[[[GFLineString alloc] initWithWKT: @"LINESTRING(100 0,101 1)"] mutableCopy] toWKTString], @"LINESTRING(100 0,101 1)");
    }

    - (void) testAddPoint_WithValidPoint {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];

        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];

        XCTAssertEqualObjects([lineString toWKTString], @"LINESTRING(100 0,101 1)");
    }

    - (void) testAddPoint_WithNilPoint{
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];
    
        XCTAssertThrowsSpecificNamed([lineString addPoint: nil], NSException, NSInvalidArgumentException);
    }

    - (void) testInsertPoint_WithValidPoint_BeforePoint {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];

        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];
        [lineString insertPoint: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"] atIndex: 0];
        
        XCTAssertEqualObjects([lineString toWKTString], @"LINESTRING(100 0,101 1)");
    }

    - (void) testInsertPoint_WithValidPoint_AtEnd {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];

        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [lineString insertPoint: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"] atIndex: 1];
    
        XCTAssertEqualObjects([lineString toWKTString], @"LINESTRING(100 0,101 1)");
    }

    - (void) testInsertPoint_WithOutOfRangeIndex {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];
    
        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];
        
        XCTAssertThrowsSpecificNamed([lineString insertPoint: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"] atIndex: 2], NSException, NSRangeException);
    }

    - (void) testInsertPoint_WithNilPoint{
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];
    
        XCTAssertThrowsSpecificNamed([lineString  insertPoint: nil atIndex: 0], NSException, NSInvalidArgumentException);
    }

    - (void) testRemoveAllPoints_WhileEmpty {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];

        XCTAssertNoThrow([lineString removeAllPoints]);
    }

    - (void) testRemoveAllPoints_WhileContainingPoints {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];

        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];
        
        [lineString removeAllPoints];
        
        XCTAssertEqualObjects([lineString toWKTString], @"LINESTRING()");
    }

    - (void) testRemovePointAtIndex_BeforePoint {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];

        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];

        [lineString removePointAtIndex: 0];

        XCTAssertEqualObjects([lineString toWKTString], @"LINESTRING(101 1)");
    }

    - (void) testRemovePointAtIndex_AtEnd {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];

        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];

        [lineString removePointAtIndex: 1];

        XCTAssertEqualObjects([lineString toWKTString], @"LINESTRING(100 0)");
    }

    - (void) testRemovePointAtIndex_WithOutOfRangeIndex {
        GFMutableLineString * lineString = [[GFMutableLineString alloc] init];

        [lineString addPoint: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];

        XCTAssertThrowsSpecificNamed([lineString removePointAtIndex: 1], NSException, NSRangeException);
    }


@end

