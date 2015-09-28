/*
*   GFMutableRingTests.m
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
*   Created by Tony Stone on 09/24/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFMutableRingTests : XCTestCase
@end

@implementation GFMutableRingTests

    - (void) testMutableCopy_IsCorrectClass {
        XCTAssertTrue([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] mutableCopy] isMemberOfClass: [GFMutableRing class]]);
    }

    - (void) testMutableCopy_IsCorrectValue {
        XCTAssertEqualObjects([[[[GFRing alloc] initWithWKT: @"LINESTRING(20 0,20 10,40 10,40 0,20 0)"] mutableCopy] toWKTString], @"LINESTRING(20 0,20 10,40 10,40 0,20 0)");
    }

    - (void) testAddPoint_WithValidPoint {
        GFMutableRing * ring = [[GFMutableRing alloc] init];

        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];

        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING(20 0,20 10,40 10,40 0,20 0)");
    }

    - (void) testAddPoint_WithNilPoint{
        GFMutableRing * ring = [[GFMutableRing alloc] init];
    
        XCTAssertThrowsSpecificNamed([ring addPoint: nil], NSException, NSInvalidArgumentException);
    }

    - (void) testInsertPoint_WithValidPoint_BeforePoint {
        GFMutableRing * ring = [[GFMutableRing alloc] init];

        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        [ring insertPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"] atIndex: 0];
        
        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING(20 0,20 10,40 10,40 0,20 0)");
    }

    - (void) testInsertPoint_WithValidPoint_AtEnd {
        GFMutableRing * ring = [[GFMutableRing alloc] init];

        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 0)"]];
        [ring insertPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"] atIndex: 4];
    
        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING(20 0,20 10,40 10,40 0,20 0)");
    }

    - (void) testInsertPoint_WithOutOfRangeIndex {
        GFMutableRing * ring = [[GFMutableRing alloc] init];
    
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        
        XCTAssertThrowsSpecificNamed([ring insertPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 10)"] atIndex: 2], NSException, NSRangeException);
    }

    - (void) testInsertPoint_WithNilPoint{
        GFMutableRing * ring = [[GFMutableRing alloc] init];
    
        XCTAssertThrowsSpecificNamed([ring  insertPoint: nil atIndex: 0], NSException, NSInvalidArgumentException);
    }

    - (void) testRemoveAllPoints_WhileEmpty {
        GFMutableRing * ring = [[GFMutableRing alloc] init];

        XCTAssertNoThrow([ring removeAllPoints]);
    }

    - (void) testRemoveAllPoints_WhileContainingPoints {
        GFMutableRing * ring = [[GFMutableRing alloc] init];

        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        
        [ring removeAllPoints];
        
        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING()");
    }

    - (void) testRemovePointAtIndex_BeforePoint {
        GFMutableRing * ring = [[GFMutableRing alloc] init];

        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(0 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];

        [ring removePointAtIndex: 0];

        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING(20 0,20 10,40 10,40 0,20 0)");
    }

    - (void) testRemovePointAtIndex_AtEnd {
        GFMutableRing * ring = [[GFMutableRing alloc] init];

        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 10)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(40 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];
        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(0 0)"]];

        [ring removePointAtIndex: 5];

        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING(20 0,20 10,40 10,40 0,20 0)");
    }

    - (void) testRemovePointAtIndex_WithOutOfRangeIndex {
        GFMutableRing * ring = [[GFMutableRing alloc] init];

        [ring addPoint: [[GFPoint alloc] initWithWKT: @"POINT(20 0)"]];

        XCTAssertThrowsSpecificNamed([ring removePointAtIndex: 1], NSException, NSRangeException);
    }

#pragma mark - Indexed Subscripting Tests

    - (void) testSetObjectAtIndexedSubscript_WithValidPointAndValidIndex {

        GFMutableRing * ring = [[GFMutableRing alloc] init];

        ring[0] = [[GFPoint alloc] initWithWKT: @"POINT(1 1)"];

        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING(1 1)");
    }

    - (void) testSetObjectAtIndexedSubscript_With5ValidPointAndValidIndex {

        GFMutableRing * ring = [[GFMutableRing alloc] init];

        ring[0] = [[GFPoint alloc] initWithWKT: @"POINT(20 0)"];
        ring[1] = [[GFPoint alloc] initWithWKT: @"POINT(20 10)"];
        ring[2] = [[GFPoint alloc] initWithWKT: @"POINT(40 10)"];
        ring[3] = [[GFPoint alloc] initWithWKT: @"POINT(40 0)"];
        ring[4] = [[GFPoint alloc] initWithWKT: @"POINT(20 0)"];

        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING(20 0,20 10,40 10,40 0,20 0)");
    }

    - (void) testSetObjectAtIndexedSubscript_WithReassignValidPointAndValidIndex {

        GFMutableRing * ring = [[GFMutableRing alloc] init];

        ring[0] = [[GFPoint alloc] initWithWKT: @"POINT(3 3)"];
        ring[1] = [[GFPoint alloc] initWithWKT: @"POINT(2 2)"];

        ring[0] = [[GFPoint alloc] initWithWKT: @"POINT(1 1)"];

        XCTAssertEqualObjects([ring toWKTString], @"LINESTRING(1 1,2 2)");
    }

    - (void) testSetObjectAtIndexedSubscript_WithNilPointAndValidIndex {

        GFMutableRing * ring = [[GFMutableRing alloc] init];

        XCTAssertThrowsSpecificNamed((ring[0] = nil), NSException, NSInvalidArgumentException);
    }

    - (void) testSetObjectAtIndexedSubscript_WithValidPointAndInvalidIndex {

        GFMutableRing * ring = [[GFMutableRing alloc] init];

        XCTAssertThrowsSpecificNamed((ring[1] = [[GFPoint alloc] initWithWKT: @"POINT(1 1)"]), NSException, NSRangeException);
    }

@end

