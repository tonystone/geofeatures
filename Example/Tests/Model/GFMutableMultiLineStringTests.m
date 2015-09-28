/*
*   GFMutableMultiLineStringTests.m
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

@interface GFMutableMultiLineStringTests : XCTestCase
@end

@implementation GFMutableMultiLineStringTests

    - (void) testMutableCopy_IsCorrectClass {
        XCTAssertTrue([[[[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0))"] mutableCopy] isMemberOfClass: [GFMutableMultiLineString class]]);
    }

    - (void) testMutableCopy_IsCorrectValue {
        XCTAssertEqualObjects([[[[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0))"] mutableCopy] toWKTString], @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0))");
    }

    - (void) testAddGeometry_WithValidLineString {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"]];
        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"]];

        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0))");
    }

    - (void) testAddGeometry_WithNilLineString {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];
    
        XCTAssertThrowsSpecificNamed([multiLineString addGeometry: nil], NSException, NSInvalidArgumentException);
    }

    - (void) testInsertGeometry_WithValidLineString_BeforeLineString {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"]];
        [multiLineString insertGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"] atIndex: 0];
        
        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0))");
    }

    - (void) testInsertGeometry_WithValidLineString_AtEnd {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"]];
        [multiLineString insertGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"] atIndex: 1];

        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0))");
    }

    - (void) testInsertGeometry_WithOutOfRangeIndex {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"]];
        
        XCTAssertThrowsSpecificNamed([multiLineString insertGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"] atIndex: 2], NSException, NSRangeException);
    }

    - (void) testInsertGeometry_WithNilLineString {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];
    
        XCTAssertThrowsSpecificNamed([multiLineString insertGeometry: nil atIndex: 0], NSException, NSInvalidArgumentException);
    }

    - (void) testRemoveAllGeometries_WhileEmpty {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        XCTAssertNoThrow([multiLineString removeAllGeometries]);
    }

    - (void) testRemoveAllGeometries_WhileContainingLineStrings {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"]];
        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"]];
        
        [multiLineString removeAllGeometries];
        
        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING()");
    }

    - (void) testRemoveGeometryAtIndex_BeforeLineString {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"]];
        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"]];

        [multiLineString removeGeometryAtIndex: 0];

        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING((5 0,10 0,5 -5,5 0))");
    }

    - (void) testRemoveGeometryAtIndex_AtEnd {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"]];
        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"]];

        [multiLineString removeGeometryAtIndex: 1];

        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING((0 0,5 0))");
    }

    - (void) testRemoveGeometryAtIndex_WithOutOfRangeIndex {
        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        [multiLineString addGeometry: [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"]];

        XCTAssertThrowsSpecificNamed([multiLineString removeGeometryAtIndex: 1], NSException, NSRangeException);
    }

#pragma mark - Indexed Subscripting Tests

    - (void) testSetObjectAtIndexedSubscript_WithValidLineStringAndValidIndex {

        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        multiLineString[0] = [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"];

        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING((0 0,5 0))");
    }

    - (void) testSetObjectAtIndexedSubscript_With3ValidLineStringsAndValidIndex {

        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        multiLineString[0] = [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"];
        multiLineString[1] = [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"];
        multiLineString[2] = [[GFLineString alloc] initWithWKT: @"LINESTRING(1 1,2 2,3 3)"];

        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(1 1,2 2,3 3))");
    }

    - (void) testSetObjectAtIndexedSubscript_WithReassignValidLineStringAndValidIndex {

        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        multiLineString[0] = [[GFLineString alloc] initWithWKT: @"LINESTRING(1 1,2 2,3 3)"];
        multiLineString[1] = [[GFLineString alloc] initWithWKT: @"LINESTRING(5 0,10 0,5 -5,5 0)"];

        multiLineString[0] = [[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,5 0)"];

        XCTAssertEqualObjects([multiLineString toWKTString], @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0))");
    }

    - (void) testSetObjectAtIndexedSubscript_WithNilLineStringAndValidIndex {

        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        XCTAssertThrowsSpecificNamed((multiLineString[0] = nil), NSException, NSInvalidArgumentException);
    }

    - (void) testSetObjectAtIndexedSubscript_WithValidLineStringAndInvalidIndex {

        GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];

        XCTAssertThrowsSpecificNamed((multiLineString[1] = [[GFLineString alloc] init]), NSException, NSRangeException);
    }

@end

