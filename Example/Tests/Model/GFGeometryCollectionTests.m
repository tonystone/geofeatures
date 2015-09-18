/*
*   GFMultiPolygonTests.m
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
*   Created by Tony Stone on 08/29/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFGeometryCollectionTests : XCTestCase
@end

@implementation GFGeometryCollectionTests

    - (void)testConstruction {
        XCTAssertNoThrow([[GFGeometryCollection alloc] init]);
        XCTAssertNotNil([[GFGeometryCollection alloc] init]);
        
        XCTAssertNoThrow([[GFGeometryCollection alloc] initWithArray: @[]]);
        XCTAssertNotNil ([[GFGeometryCollection alloc] initWithArray: @[]]);


        XCTAssertNoThrow([[GFGeometryCollection alloc] initWithArray: (@[[[GFPolygon alloc] initWithWKT: @"POLYGON((120 0,120 90,210 90,210 0,120 0))"],[[GFLineString alloc] initWithWKT: @"LINESTRING(40 50,40 140)"]])]);
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithArray: (@[[[GFPolygon alloc] initWithWKT: @"POLYGON((120 0,120 90,210 90,210 0,120 0))"],[[GFLineString alloc] initWithWKT: @"LINESTRING(40 50,40 140)"]])] toWKTString], @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))");

        XCTAssertThrowsSpecificNamed([[GFGeometryCollection alloc] initWithArray: (@[ [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"]])], NSException, NSInvalidArgumentException);
        XCTAssertThrowsSpecificNamed([[GFGeometryCollection alloc] initWithArray: @[[[NSObject alloc] init]]], NSException, NSInvalidArgumentException);
    }

    - (void)testFailedConstruction {
//        XCTAssertThrowsSpecificNamed([[GFGeometryCollection alloc] initWithGeoJSONGeometry:  @{@"invalid": @{}}], NSException, NSInvalidArgumentException);
        XCTAssertThrows([[GFGeometryCollection alloc] initWithWKT: @"INVALID()"]);
    }

    - (void) testDescription {
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithWKT:
                @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))"] description],
                @"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
    }

#pragma mark - Querying Tests

    - (void) testCount {

        XCTAssertEqual([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] count], 0);
        XCTAssertEqual([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)))"] count], 1);
        XCTAssertEqual([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] count], 2);
    }

    - (void) testObjectAtIndex {

        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] geometryAtIndex: 0] toWKTString], @"POLYGON((120 0,120 90,210 90,210 0,120 0))");
        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] geometryAtIndex: 1] toWKTString], @"LINESTRING(40 50,40 140)");

        XCTAssertThrowsSpecificNamed(([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)))"] geometryAtIndex: 1]), NSException, NSRangeException);
    }

    - (void) testFirstObject {

        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] firstGeometry] toWKTString], @"POLYGON((120 0,120 90,210 90,210 0,120 0))");

        XCTAssertNoThrow([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] firstGeometry]);
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] firstGeometry], nil);
    }

    - (void) testLastObject {

        XCTAssertEqualObjects([[[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"] lastGeometry] toWKTString], @"LINESTRING(40 50,40 140)");

        XCTAssertNoThrow([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] lastGeometry]);
        XCTAssertEqualObjects([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] lastGeometry], nil);
    }

#pragma mark - Indexed Subscript Tests

    - (void) testObjectAtIndexedSubscript {

        GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"];

        XCTAssertNoThrow(geometryCollection[0]);
        XCTAssertNoThrow(geometryCollection[1]);
        XCTAssertThrowsSpecificNamed(geometryCollection[2], NSException, NSRangeException);

        XCTAssertEqualObjects([geometryCollection[0] toWKTString], @"POLYGON((120 0,120 90,210 90,210 0,120 0))");
        XCTAssertEqualObjects([geometryCollection[1] toWKTString], @"LINESTRING(40 50,40 140)");
    }

@end
