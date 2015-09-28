/*
*   GFMutableGeometryCollectionTests.m
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
*   Created by Tony Stone on 09/26/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFMutableGeometryCollectionTests : XCTestCase
@end

@implementation GFMutableGeometryCollectionTests

    - (void) testMutableCopy_IsCorrectClass {
        XCTAssertTrue([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] mutableCopy] isMemberOfClass: [GFMutableGeometryCollection class]]);
    }

    - (void) testMutableCopy_IsCorrectValue {
        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))"] mutableCopy] toWKTString], @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }

    - (void) testAddGeometry_WithValidPolygon {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];

        XCTAssertEqualObjects([geometryCollection toWKTString], @"GEOMETRYCOLLECTION(POLYGON((20 0,20 10,40 10,40 0,20 0)),POLYGON((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testAddGeometry_WithNilPolygon {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];
    
        XCTAssertThrowsSpecificNamed([geometryCollection addGeometry: nil], NSException, NSInvalidArgumentException);
    }

    - (void) testAddGeometry_WithIncorrectObjectType {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        XCTAssertThrowsSpecificNamed([geometryCollection addGeometry: [[NSObject alloc] init]], NSException, NSInvalidArgumentException);
    }

    - (void) testInsertGeometry_WithValidPolygon_BeforePolygon {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];
        [geometryCollection insertGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"] atIndex: 0];
        
        XCTAssertEqualObjects([geometryCollection toWKTString], @"GEOMETRYCOLLECTION(POLYGON((20 0,20 10,40 10,40 0,20 0)),POLYGON((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testInsertGeometry_WithValidPolygon_AtEnd {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [geometryCollection insertGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"] atIndex: 1];

        XCTAssertEqualObjects([geometryCollection toWKTString], @"GEOMETRYCOLLECTION(POLYGON((20 0,20 10,40 10,40 0,20 0)),POLYGON((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testInsertGeometry_WithOutOfRangeIndex {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        
        XCTAssertThrowsSpecificNamed([geometryCollection insertGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"] atIndex: 2], NSException, NSRangeException);
    }

    - (void) testInsertGeometry_WithNilPolygon {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        XCTAssertThrowsSpecificNamed([geometryCollection insertGeometry: nil atIndex: 0], NSException, NSInvalidArgumentException);
    }

    - (void) testInsertGeometry_WithIncorrectObjectType {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        XCTAssertThrowsSpecificNamed([geometryCollection insertGeometry: [[NSObject alloc] init] atIndex: 0], NSException, NSInvalidArgumentException);
    }

    - (void) testRemoveAllGeometries_WhileEmpty {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        XCTAssertNoThrow([geometryCollection removeAllGeometries]);
    }

    - (void) testRemoveAllGeometries_WhileContainingPolygons {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];
        
        [geometryCollection removeAllGeometries];
        
        XCTAssertEqualObjects([geometryCollection toWKTString], @"GEOMETRYCOLLECTION()");
    }

    - (void) testRemoveGeometryAtIndex_BeforePolygon {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];

        [geometryCollection removeGeometryAtIndex: 0];

        XCTAssertEqualObjects([geometryCollection toWKTString], @"GEOMETRYCOLLECTION(POLYGON((5 5,5 8,8 8,8 5,5 5)))");
    }

    - (void) testRemoveGeometryAtIndex_AtEnd {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];
        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((5 5,5 8,8 8,8 5,5 5))"]];

        [geometryCollection removeGeometryAtIndex: 1];

        XCTAssertEqualObjects([geometryCollection toWKTString], @"GEOMETRYCOLLECTION(POLYGON((20 0,20 10,40 10,40 0,20 0)))");
    }

    - (void) testRemoveGeometryAtIndex_WithOutOfRangeIndex {
        GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];

        [geometryCollection addGeometry: [[GFPolygon alloc] initWithWKT: @"POLYGON((20 0,20 10,40 10,40 0,20 0))"]];

        XCTAssertThrowsSpecificNamed([geometryCollection removeGeometryAtIndex: 1], NSException, NSRangeException);
    }


@end

