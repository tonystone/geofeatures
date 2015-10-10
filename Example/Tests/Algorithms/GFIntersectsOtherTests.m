/*
*   GFIntersectsOtherTests.m
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
*   Created by Tony Stone on 10/7/2015.
*/

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFIntersectsOtherTests : XCTestCase
@end

@implementation GFIntersectsOtherTests

#pragma mark - Point Box

    - (void) testIntersectsOther_Point_Box_Intersecting {
        XCTAssertEqual([[[GFPoint alloc] initWithWKT:@"POINT(1 1)"] intersects: [[GFBox alloc] initWithWKT:@"BOX(0 0,2 2)"] ], true);
    }

#pragma mark - Point LineString

    - (void) testIntersectsOther_Point_LineString_Intersecting {
        XCTAssertEqual([[[GFPoint alloc] initWithWKT:@"POINT(1 1)"] intersects: [[GFLineString alloc] initWithWKT:@"LINESTRING(0 0,2 2,4 0)"] ], true);
    }

    - (void) testIntersectsOther_Point_LineString_NonIntersecting {
        XCTAssertEqual([[[GFPoint alloc] initWithWKT:@"POINT(1 0)"] intersects: [[GFLineString alloc] initWithWKT:@"LINESTRING(0 0,2 2,4 0)"] ], false);
    }

#pragma mark - Point MultiPolygon

    - (void) testIntersectsOther_Point_MultiPolygon_Intersecting {
        XCTAssertEqual([[[GFPoint alloc] initWithWKT:@"POINT(0 0)"] intersects: [[GFMultiPolygon alloc] initWithWKT:@"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))"] ], true);
    }

#pragma mark - LineString Polygon

    - (void) testIntersectsOther_LineString_Polygon_Intersecting {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING(1 1,2 2)"] intersects: [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0,10 0,10 10,0 10,0 0))"] ], true);
    }

    - (void) testIntersectsOther_LineString_Polygon_NonIntersecting {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING(11 0,12 12)"] intersects: [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0,10 0,10 10,0 10,0 0))"] ], false);
    }

#pragma mark - LineString MultiPolygon

    - (void) testIntersectsOther_LineString_MultiPolygon_Intersecting {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING(1 1,2 2)"] intersects: [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((0 0,10 0,10 10,0 10,0 0)))"] ], true);
    }

#pragma mark - LineString Box

    - (void) testIntersectsOther_LineString_Box_Intersecting {
        XCTAssertEqual([[[GFLineString alloc] initWithWKT: @"LINESTRING(0 0,1 0,10 10)"] intersects: [[GFBox alloc] initWithWKT: @"BOX(1 2,3 5)"] ], true);
    }

#pragma mark - Ring MultiPolygon

    - (void) testIntersectsOther_Ring_MultiPolygon_Intersecting {
        XCTAssertEqual([[[GFRing alloc] initWithWKT:@"LINESTRING(1 1, 3 3, 2 5)"] intersects: [[GFMultiPolygon alloc] initWithWKT:@"MULTIPOLYGON(((0 0,10 0,10 10,0 10,0 0)))"] ], true);
    }

    - (void) testIntersectsOther_Ring_MultiPolygon_NonIntersecting {
        XCTAssertEqual([[[GFRing alloc] initWithWKT:@"LINESTRING(6 6, 7 6, 7 7, 6 7)"] intersects: [[GFMultiPolygon alloc] initWithWKT:@"MULTIPOLYGON(((0 0,10 0,10 10,0 10,0 0)))"] ], true);
    }

#pragma mark - Polygon Polygon

    - (void) testIntersectsOther_Polygon_Polygon_Intersecting {
        XCTAssertEqual([[[GFPolygon alloc] initWithWKT: @"POLYGON((1 1, 3 3, 2 5))"] intersects: [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0, 9 0, 9 9, 0 9),(5 5,5 8,8 8,8 5))"] ], true);
    }

    - (void) testIntersectsOther_Polygon_Polygon_NonIntersecting {
        XCTAssertEqual([[[GFPolygon alloc] initWithWKT: @"POLYGON((6 6, 7 6, 7 7, 6 7))"] intersects: [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0, 9 0, 9 9, 0 9),(5 5,5 8,8 8,8 5))"] ], false);
    }

#pragma mark - Polygon LineString

    - (void) testIntersectsOther_Polygon_LineString_Intersecting {
        XCTAssertEqual([[[GFPolygon alloc] initWithWKT: @"POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))"] intersects: [[GFLineString alloc] initWithWKT: @"LINESTRING(-2 -2, 12 7)"] ], true);
    }

#pragma mark - Polygon Box

    - (void) testIntersectsOther_Polygon_Box_Intersecting {
        XCTAssertEqual([[[GFPolygon alloc] initWithWKT: @"POLYGON((1992 3240,1992 1440,3792 1800,3792 3240,1992 3240))"] intersects: [[GFBox alloc] initWithWKT: @"BOX(1941 2066, 2055 2166)"] ], true);
    }

#pragma makr - MultiLineString Polygon

    - (void) testIntersectsOther_MultiLineString_Polygon_Intersecting {
        XCTAssertEqual([[[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((11 11, 20 20),(5 7, 4 1))"] intersects: [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,4 2,4 4,2 4,2 2))"] ], true);
    }

#pragma mark - MultiPolygon Polygon

    - (void) testIntersectsOther_MultiPolygon_Polygon_Intersecting {
        XCTAssertEqual([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((11 11,11 20,20 20,20 11,11 11)),((5 5,5 6,6 6,6 5,5 5)))"] intersects: [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,4 2,4 4,2 4,2 2))"] ], true);
    }

#pragma mark - MultiPolygon MultiPolygon

    - (void) testIntersectsOther_MultiPolygon_MultiPolygon_Intersecting {
        XCTAssertEqual([[[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))"] intersects: [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))"] ], true);
    }

#pragma mark - MultiLineString MultiPolygon

    - (void) testIntersectsOther_MultiLineString_MultiPolygon_Intersecting {
        XCTAssertEqual([[[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((1 1,2 2))"] intersects: [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((0 0,10 0,10 10,0 10,0 0)))"] ], true);
    }

@end