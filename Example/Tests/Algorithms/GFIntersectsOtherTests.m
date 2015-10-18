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

#define IntersectsTest(T1,input1,T2, input2,expected) XCTAssertEqual([[[T1 alloc] initWithWKT: (input1)] intersects: [[T2 alloc] initWithWKT: (input2)]], (expected))


@implementation GFIntersectsOtherTests

#pragma mark - Point
#pragma mark -

    - (void) testIntersectsOther_Point_Box_Intersecting {
        IntersectsTest(GFPoint, @"POINT(1 1)", GFBox, @"BOX(0 0,2 2)", true);
    }

#pragma mark -

    - (void) testIntersectsOther_Point_LineString_Intersecting {
        IntersectsTest(GFPoint, @"POINT(1 1)", GFLineString, @"LINESTRING(0 0,2 2,4 0)", true);
    }

    - (void) testIntersectsOther_Point_LineString_NonIntersecting {
        IntersectsTest(GFPoint, @"POINT(1 0)", GFLineString, @"LINESTRING(0 0,2 2,4 0)",  false);
    }

#pragma mark -     

    - (void) testIntersectsOther_Point_Polygon_NonIntersecting_InWhole {
        IntersectsTest(GFPoint,  @"POINT(3 3)", GFPolygon,  @"POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,2 4,4 4,4 2,2 2))",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_Point_MultiPoint_Intersecting {
        IntersectsTest(GFPoint,  @"POINT(4 4)", GFMultiPoint,  @"MULTIPOINT(1 1,3 3,4 4,10 10)",  true);
    }

    - (void) testIntersectsOther_Point_MultiPoint_NonIntersecting {
        IntersectsTest(GFPoint,  @"POINT(4 5)", GFMultiPoint,  @"MULTIPOINT(1 1,3 3,4 4,10 10)",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_Point_MultiPolygon_Intersecting {
        IntersectsTest(GFPoint, @"POINT(0 0)", GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_Point_GeometryCollection_Polygon_Intersecting {
        IntersectsTest(GFPoint,  @"POINT(9 9)", GFGeometryCollection,  @"GEOMETRYCOLLECTION(POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,2 4,4 4,4 2,2 2)))",  true);
    }

    - (void) testIntersectsOther_Point__GeometryCollectionPolygon_NonIntersecting {
        IntersectsTest(GFPoint,  @"POINT(3 3)", GFGeometryCollection,  @"GEOMETRYCOLLECTION(POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,2 4,4 4,4 2,2 2)))",  false);
    }

#pragma mark - Box
#pragma mark -

    - (void) testIntersectsOther_Box_Point_Intersecting {
        IntersectsTest(GFBox, @"BOX(0 0,2 2)", GFPoint, @"POINT(1 1)", true);
    }

#pragma mark -

    - (void) testIntersectsOther_Box_GeometryCollection_Point_Intersecting {
        IntersectsTest(GFBox, @"BOX(0 0,2 2)", GFGeometryCollection , @"GEOMETRYCOLLECTION(POINT(1 1))", true);
    }

#pragma mark - LineString
#pragma mark -

    - (void) testIntersectsOther_LineString_Polygon_Intersecting {
        IntersectsTest(GFLineString,  @"LINESTRING(1 1,2 2)", GFPolygon,  @"POLYGON((0 0,10 0,10 10,0 10,0 0))",  true);
    }

    - (void) testIntersectsOther_LineString_Polygon_NonIntersecting {
        IntersectsTest(GFLineString,  @"LINESTRING(11 0,12 12)", GFPolygon,  @"POLYGON((0 0,10 0,10 10,0 10,0 0))",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_LineString_MultiPolygon_Intersecting {
        IntersectsTest(GFLineString,  @"LINESTRING(1 1,2 2)", GFMultiPolygon,  @"MULTIPOLYGON(((0 0,10 0,10 10,0 10,0 0)))",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_LineString_Box_Intersecting {
        IntersectsTest(GFLineString,  @"LINESTRING(0 0,1 0,10 10)", GFBox,  @"BOX(1 2,3 5)",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_LineString_GeometryCollection_Polygon_Intersecting {
        IntersectsTest(GFLineString,  @"LINESTRING(1 1,2 2)", GFGeometryCollection,  @"GEOMETRYCOLLECTION(POLYGON((0 0,10 0,10 10,0 10,0 0)))",  true);
    }

    - (void) testIntersectsOther_LineString_GeometryCollection_Polygon_NonIntersecting {
        IntersectsTest(GFLineString,  @"LINESTRING(11 0,12 12)", GFGeometryCollection,  @"GEOMETRYCOLLECTION(POLYGON((0 0,10 0,10 10,0 10,0 0)))",  false);
    }

#pragma mark - Ring
#pragma mark -

    - (void) testIntersectsOther_Ring_MultiPolygon_Intersecting {
        IntersectsTest(GFRing, @"LINESTRING(1 1, 3 3, 2 5,1 1)", GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))",  true);
    }

    - (void) testIntersectsOther_Ring_MultiPolygon_NonIntersecting {
        IntersectsTest(GFRing, @"LINESTRING(16 16,16 17, 17 17,17 16,16 16)", GFMultiPolygon, @"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_Ring_MultiPoint_Intersecting {
        IntersectsTest(GFRing,  @"LINESTRING(2 2,2 5, 5 5,5 2,2 2)", GFMultiPoint,  @"MULTIPOINT(1 1,3 4,4 4,10 10)", true);
    }

    - (void) testIntersectsOther_Ring_MultiPoint_NonIntersecting {
        IntersectsTest(GFRing,  @"LINESTRING(2 2,2 5, 5 5,5 2,2 2)", GFMultiPoint,  @"MULTIPOINT(1 1,1 6,2 6,10 10)", false);
    }

#pragma mark -

    - (void) testIntersectsOther_Ring__GeometryCollectionMultiPolygon_Intersecting {
        IntersectsTest(GFRing, @"LINESTRING(1 1, 3 3, 2 5,1 1)", GFGeometryCollection, @"GEOMETRYCOLLECTION(MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0))))",  true);
    }

    - (void) testIntersectsOther_Ring__GeometryCollectionMultiPolygon_NonIntersecting {
        IntersectsTest(GFRing, @"LINESTRING(16 16, 17 16, 17 17, 16 17,16 16)", GFGeometryCollection, @"GEOMETRYCOLLECTION(MULTIPOLYGON(((0 0,10 0,10 10,0 10,0 0))))",  false);
    }

#pragma mark - Polygon
#pragma mark -

    - (void) testIntersectsOther_Polygon_Polygon_Intersecting {
        IntersectsTest(GFPolygon,  @"POLYGON((1 1, 3 3, 2 5))", GFPolygon,  @"POLYGON((0 0, 9 0, 9 9, 0 9),(5 5,5 8,8 8,8 5))",  true);
    }

    - (void) testIntersectsOther_Polygon_Polygon_NonIntersecting {
        IntersectsTest(GFPolygon,  @"POLYGON((6 6, 7 6, 7 7, 6 7))", GFPolygon,  @"POLYGON((0 0, 9 0, 9 9, 0 9),(5 5,5 8,8 8,8 5))",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_Polygon_LineString_Intersecting {
        IntersectsTest(GFPolygon,  @"POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))", GFLineString,  @"LINESTRING(-2 -2, 12 7)",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_Polygon_Box_Intersecting {
        IntersectsTest(GFPolygon,  @"POLYGON((1992 3240,1992 1440,3792 1800,3792 3240,1992 3240))", GFBox,  @"BOX(1941 2066, 2055 2166)",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_Polygon_MultiPoint_Intersecting {
        IntersectsTest(GFPolygon,  @"POLYGON((2 2,2 5, 5 5,5 2,2 2))", GFMultiPoint,  @"MULTIPOINT(1 1,3 4,4 4,10 10)",  true);
    }

    - (void) testIntersectsOther_Polygon_MultiPoint_NonIntersecting {
        IntersectsTest(GFPolygon,  @"POLYGON((2 2,2 5, 5 5,5 2,2 2))", GFMultiPoint,  @"MULTIPOINT(1 1,1 6,2 6,10 10)",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_Polygon_GeometryCollection_MultiPoint_Intersecting {
        IntersectsTest(GFPolygon,  @"POLYGON((2 2,2 5, 5 5,5 2,2 2))", GFGeometryCollection,  @"GEOMETRYCOLLECTION(MULTIPOINT(1 1,3 4,4 4,10 10))",  true);
    }

    - (void) testIntersectsOther_Polygon_GeometryCollection_MultiPoint_NonIntersecting {
        IntersectsTest(GFPolygon,  @"POLYGON((2 2,2 5, 5 5,5 2,2 2))", GFGeometryCollection,  @"GEOMETRYCOLLECTION(MULTIPOINT(1 1,1 6,2 6,10 10))",  false);
    }

#pragma mark - MultiPoint
#pragma mark -

    - (void) testIntersectsOther_MultiPoint_Point_Intersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,3 3,4 4,10 10)", GFPoint,  @"POINT(4 4)",  true);
    }

    - (void) testIntersectsOther_MultiPoint_Point_NonIntersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,3 3,4 4,10 10)", GFPoint,  @"POINT(4 5)",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiPoint_Ring_Intersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,3 4,4 4,10 10)", GFRing,  @"LINESTRING(2 2,2 5, 5 5,5 2,2 2)",  true);
    }

    - (void) testIntersectsOther_MultiPoint_Ring_NonIntersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,1 6,2 6,10 10)", GFRing,  @"LINESTRING(2 2,2 5, 5 5,5 2,2 2)",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiPoint_Polygon_Intersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,3 4,4 4,10 10)", GFPolygon,  @"POLYGON((2 2,2 5, 5 5,5 2,2 2))",  true);
    }

    - (void) testIntersectsOther_MultiPoint_Polygon_NonIntersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,1 6,2 6,10 10)", GFPolygon,  @"POLYGON((2 2,2 5, 5 5,5 2,2 2))",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiPoint_MultiPolygon_Intersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,3 4,4 4,10 10)", GFMultiPolygon,  @"MULTIPOLYGON(((2 2,2 5, 5 5,5 2,2 2)))",  true);
    }

    - (void) testIntersectsOther_MultiPoint_MultiPolygon_NonIntersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,1 6,2 6,10 10)", GFMultiPolygon,  @"MULTIPOLYGON(((2 2,2 5, 5 5,5 2,2 2)))",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiPoint_GeometryCollection_MultiPolygon_Intersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,3 4,4 4,10 10)", GFGeometryCollection,  @"GEOMETRYCOLLECTION(MULTIPOLYGON(((2 2,2 5, 5 5,5 2,2 2))))",  true);
    }

    - (void) testIntersectsOther_MultiPoint_GeometryCollection_MultiPolygon_NonIntersecting {
        IntersectsTest(GFMultiPoint,  @"MULTIPOINT(1 1,1 6,2 6,10 10)", GFGeometryCollection,  @"GEOMETRYCOLLECTION(MULTIPOLYGON(((2 2,2 5, 5 5,5 2,2 2))))",  false);
    }

#pragma mark - MultiLineString
#pragma mark -

    - (void) testIntersectsOther_MultiLineString_Polygon_Intersecting {
        IntersectsTest(GFMultiLineString,  @"MULTILINESTRING((11 11, 20 20),(5 7, 4 1))", GFPolygon,  @"POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,4 2,4 4,2 4,2 2))",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiLineString_MultiPolygon_Intersecting {
        IntersectsTest(GFMultiLineString,  @"MULTILINESTRING((1 1,2 2))", GFMultiPolygon,  @"MULTIPOLYGON(((0 0,10 0,10 10,0 10,0 0)))",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiLineString_GeometryCollection_MultiLineString_Intersecting {
        IntersectsTest(GFMultiLineString,  @"MULTILINESTRING((1 0,1 1,1 2))", GFGeometryCollection,  @"GEOMETRYCOLLECTION(MULTILINESTRING((0 5,0 6,0 7,0 8),(1 1,2 2)))",  true);
    }

    - (void) testIntersectsOther_MultiLineString_GeometryCollection_MultiLineString_NonIntersecting {
        IntersectsTest(GFMultiLineString,  @"MULTILINESTRING((5 0,6 0,7 0))", GFGeometryCollection,  @"GEOMETRYCOLLECTION(MULTILINESTRING((0 5,0 6,0 7,0 8),(1 1,2 2)))",  false);
    }

#pragma mark - MultiPolygon
#pragma mark -

    - (void) testIntersectsOther_MultiPolygon_Polygon_Intersecting {
        IntersectsTest(GFMultiPolygon,  @"MULTIPOLYGON(((11 11,11 20,20 20,20 11,11 11)),((5 5,5 6,6 6,6 5,5 5)))", GFPolygon,  @"POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,4 2,4 4,2 4,2 2))",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiPolygon_MultiPoint_Intersecting {
        IntersectsTest(GFMultiPolygon,  @"MULTIPOLYGON(((2 2,2 5, 5 5,5 2,2 2)))", GFMultiPoint,  @"MULTIPOINT(1 1,3 4,4 4,10 10)",  true);
    }

    - (void) testIntersectsOther_MultiPolygon_MultiPoint_NonIntersecting {
        IntersectsTest(GFMultiPolygon,  @"MULTIPOLYGON(((2 2,2 5, 5 5,5 2,2 2)))", GFMultiPoint,  @"MULTIPOINT(1 1,1 6,2 6,10 10)",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiPolygon_MultiPolygon_Intersecting {
        IntersectsTest(GFMultiPolygon,  @"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))", GFMultiPolygon,  @"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))",  true);
    }

#pragma mark -

    - (void) testIntersectsOther_MultiPolygon_GeometryCollection_MultiPolygon_Intersecting {
        IntersectsTest(GFMultiPolygon,  @"MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))", GFGeometryCollection ,  @"GEOMETRYCOLLECTION(MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0))))",  true);
    }

    - (void) testIntersectsOther_MultiPolygon_GeometryCollection_MultiPolygon_NonIntersecting {
        IntersectsTest(GFMultiPolygon,  @"MULTIPOLYGON(((20 20,20 30,30 30,30 20,20 20)))", GFGeometryCollection ,  @"GEOMETRYCOLLECTION(MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0))))",  false);
    }

#pragma mark - GeometryCollection
#pragma mark -

    - (void) testIntersectsOther_GeometryCollection_Point_Polygon_Intersecting {
        IntersectsTest(GFGeometryCollection,  @"GEOMETRYCOLLECTION(POINT(9 9))", GFPolygon,  @"POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,2 4,4 4,4 2,2 2))",  true);
    }

    - (void) testIntersectsOther_GeometryCollection_Point_Polygon_NonIntersecting {
        IntersectsTest(GFGeometryCollection,  @"GEOMETRYCOLLECTION(POINT(3 3))", GFPolygon,  @"POLYGON((0 0,0 10,10 10,10 0,0 0),(2 2,2 4,4 4,4 2,2 2))",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_GeometryCollection_Point_LineString_Intersecting {
        IntersectsTest(GFGeometryCollection, @"GEOMETRYCOLLECTION(POINT(1 1))", GFLineString, @"LINESTRING(0 0,2 2,4 0)",  true);
    }

    - (void) testIntersectsOther_GeometryCollection_Point_LineString_NonIntersecting {
        IntersectsTest(GFGeometryCollection,  @"GEOMETRYCOLLECTION(POINT(1 0))", GFLineString,  @"LINESTRING(0 0,2 2,4 0)",  false);
    }

#pragma mark -

    - (void) testIntersectsOther_GeometryCollection_LineString_Polygon_Intersecting {
        IntersectsTest(GFGeometryCollection,  @"GEOMETRYCOLLECTION(LINESTRING(1 1,2 2))", GFPolygon,  @"POLYGON((0 0,10 0,10 10,0 10,0 0))",  true);
    }

    - (void) testIntersectsOther_GeometryCollection_LineString_Polygon_NonIntersecting {
        IntersectsTest(GFGeometryCollection,  @"GEOMETRYCOLLECTION(LINESTRING(11 0,12 12))", GFPolygon,  @"POLYGON((0 0,10 0,10 10,0 10,0 0))",  false);
    }

@end