/*
*   GFMutableMultiPolygonTests.m
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

@interface GFMutableMultiPolygonTests : XCTestCase
@end

@implementation GFMutableMultiPolygonTests

    - (void) testMutableCopy_IsCorrectClass {
        XCTAssertTrue([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] mutableCopy] isMemberOfClass: [GFMutableMultiPolygon class]]);
    }

    - (void) testMutableCopy_IsCorrectValue {
        XCTAssertEqualObjects([[[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"] mutableCopy] toWKTString], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testAddGeometry_WithValidPolygon {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];

        XCTAssertEqualObjects([multiPolygon toWKTString], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testAddGeometry_WithNilPolygon {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];
    
        XCTAssertThrowsSpecificNamed([multiPolygon addGeometry: nil], NSException, NSInvalidArgumentException);
    }

    - (void) testInsertGeometry_WithValidPolygon_BeforePolygon {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];
        [multiPolygon insertGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"] atIndex: 0];
        
        XCTAssertEqualObjects([multiPolygon toWKTString], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testInsertGeometry_WithValidPolygon_AtEnd {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [multiPolygon insertGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"] atIndex: 1];

        XCTAssertEqualObjects([multiPolygon toWKTString], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testInsertGeometry_WithOutOfRangeIndex {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        
        XCTAssertThrowsSpecificNamed([multiPolygon insertGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"] atIndex: 2], NSException, NSRangeException);
    }

    - (void) testInsertGeometry_WithNilPolygon {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];
    
        XCTAssertThrowsSpecificNamed([multiPolygon insertGeometry: nil atIndex: 0], NSException, NSInvalidArgumentException);
    }

    - (void) testRemoveAllGeometries_WhileEmpty {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        XCTAssertNoThrow([multiPolygon removeAllGeometries]);
    }

    - (void) testRemoveAllGeometries_WhileContainingPolygons {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];
        
        [multiPolygon removeAllGeometries];
        
        XCTAssertEqualObjects([multiPolygon toWKTString], @"MULTIPOLYGON()");
    }

    - (void) testRemoveGeometryAtIndex_BeforePolygon {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];

        [multiPolygon removeGeometryAtIndex: 0];

        XCTAssertEqualObjects([multiPolygon toWKTString], @"MULTIPOLYGON(((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testRemoveGeometryAtIndex_AtEnd {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];

        [multiPolygon removeGeometryAtIndex: 1];

        XCTAssertEqualObjects([multiPolygon toWKTString], @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)))");
    }

    - (void) testRemoveGeometryAtIndex_WithOutOfRangeIndex {
        GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];

        [multiPolygon addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];

        XCTAssertThrowsSpecificNamed([multiPolygon removeGeometryAtIndex: 1], NSException, NSRangeException);
    }


@end

