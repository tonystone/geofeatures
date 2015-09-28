/*
*   GFMutableMultiPointTests.m
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

@interface GFMutableMultiPointTests : XCTestCase
@end

@implementation GFMutableMultiPointTests

    - (void) testMutableCopy_IsCorrectClass {
        XCTAssertTrue([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((100 0),(101 1))"] mutableCopy] isMemberOfClass: [GFMutableMultiPoint class]]);
    }

    - (void) testMutableCopy_IsCorrectValue {
        XCTAssertEqualObjects([[[[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((100 0),(101 1))"] mutableCopy] toWKTString], @"MULTIPOINT((100 0),(101 1))");
    }

    - (void) testAddPoint_WithValidPoint {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];

        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT((100 0),(101 1))");
    }

    - (void) testAddPoint_WithNilPoint{
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];
    
        XCTAssertThrowsSpecificNamed([multiPoint addGeometry: nil], NSException, NSInvalidArgumentException);
    }

    - (void) testInsertPoint_WithValidPoint_BeforePoint {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];
        [multiPoint insertGeometry: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"] atIndex: 0];
        
        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT((100 0),(101 1))");
    }

    - (void) testInsertPoint_WithValidPoint_AtEnd {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];
    
        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [multiPoint insertGeometry: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"] atIndex: 1];
    
        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT((100 0),(101 1))");
    }

    - (void) testInsertPoint_WithOutOfRangeIndex {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];
    
        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];
        
        XCTAssertThrowsSpecificNamed([multiPoint insertGeometry: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"] atIndex: 2], NSException, NSRangeException);
    }

    - (void) testInsertPoint_WithNilPoint{
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];
    
        XCTAssertThrowsSpecificNamed([multiPoint  insertGeometry: nil atIndex: 0], NSException, NSInvalidArgumentException);
    }

    - (void) testRemoveAllPoints_WhileEmpty {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        XCTAssertNoThrow([multiPoint removeAllGeometries]);
    }

    - (void) testRemoveAllPoints_WhileContainingPoints {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];
        
        [multiPoint removeAllGeometries];
        
        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT()");
    }

    - (void) testRemovePointAtIndex_BeforePoint {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];

        [multiPoint removeGeometryAtIndex: 0];

        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT((101 1))");
    }

    - (void) testRemovePointAtIndex_AtEnd {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(100 0)"]];
        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];

        [multiPoint removeGeometryAtIndex: 1];

        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT((100 0))");
    }

    - (void) testRemovePointAtIndex_WithOutOfRangeIndex {
        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        [multiPoint addGeometry: [[GFPoint alloc] initWithWKT: @"POINT(101 1)"]];

        XCTAssertThrowsSpecificNamed([multiPoint removeGeometryAtIndex: 1], NSException, NSRangeException);
    }

#pragma mark - Indexed Subscripting Tests

    - (void) testSetObjectAtIndexedSubscript_WithValidPointAndValidIndex {

        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        multiPoint[0] = [[GFPoint alloc] initWithWKT: @"POINT(1 1)"];

        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT((1 1))");
    }

    - (void) testSetObjectAtIndexedSubscript_With3ValidPointAndValidIndex {

        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        multiPoint[0] = [[GFPoint alloc] initWithWKT: @"POINT(1 1)"];
        multiPoint[1] = [[GFPoint alloc] initWithWKT: @"POINT(2 2)"];
        multiPoint[2] = [[GFPoint alloc] initWithWKT: @"POINT(3 3)"];

        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT((1 1),(2 2),(3 3))");
    }

    - (void) testSetObjectAtIndexedSubscript_WithReassignValidPointAndValidIndex {

        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        multiPoint[0] = [[GFPoint alloc] initWithWKT: @"POINT(3 3)"];
        multiPoint[1] = [[GFPoint alloc] initWithWKT: @"POINT(2 2)"];

        multiPoint[0] = [[GFPoint alloc] initWithWKT: @"POINT(1 1)"];

        XCTAssertEqualObjects([multiPoint toWKTString], @"MULTIPOINT((1 1),(2 2))");
    }

    - (void) testSetObjectAtIndexedSubscript_WithNilPointAndValidIndex {

        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        XCTAssertThrowsSpecificNamed((multiPoint[0] = nil), NSException, NSInvalidArgumentException);
    }

    - (void) testSetObjectAtIndexedSubscript_WithValidPointAndInvalidIndex {

        GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];

        XCTAssertThrowsSpecificNamed((multiPoint[1] = [[GFPoint alloc] initWithWKT: @"POINT(1 1)"]), NSException, NSRangeException);
    }

@end

