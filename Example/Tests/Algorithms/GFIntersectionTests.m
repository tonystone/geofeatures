//
//
//  GFIntersectionTests.m
//  GeoFeatures
//
//  Created by Tony Stone on 4/17/16.
//  Copyright © 2016 Tony Stone. All rights reserved.
//

@import XCTest;
@import GeoFeatures;

@interface GFIntersectionTests : XCTestCase
@end

#define IntersectionTest(T1,input1,T2, input2,expected) XCTAssertEqualObjects([[[[T1 alloc] initWithWKT: (input1)] intersection: [[T2 alloc] initWithWKT: (input2)]] toWKTString], (expected))

@implementation GFIntersectionTests

- (void) testIntersection_Point_Point {
    IntersectionTest(GFPoint, @"POINT(1 1)", GFPoint, @"POINT(1 1)", @"POINT(1 1)");
}

- (void) testIntersection_Point_MultiPoint {
    IntersectionTest(GFPoint, @"POINT(1 1)", GFMultiPoint, @"MULTIPOINT((0 0),(1 1))", @"POINT(1 1)");
}

- (void) testIntersection_Point_LineString {
    IntersectionTest(GFPoint, @"POINT(1 1)", GFLineString, @"LINESTRING(0 0,2 2)", @"POINT(1 1)");
}

- (void) testIntersection_Point_MultiLineString {
    IntersectionTest(GFPoint, @"POINT(1 1)", GFMultiLineString, @"MULTILINESTRING((0 0,2 2))", @"POINT(1 1)");
}

- (void) testIntersection_MutliPoint_Point {
    IntersectionTest(GFMultiPoint, @"MULTIPOINT(0 0,0 0,1 0)", GFPoint, @"POINT(1 0)", @"POINT(1 0)");
}

- (void) testIntersection_MutliPoint_MultiPoint {
    IntersectionTest(GFMultiPoint, @"MULTIPOINT(2 2,3 3,0 0,0 0,2 2,1 1,1 1,1 0,1 0)", GFMultiPoint, @"MULTIPOINT(1 0,1 1,1 1,1 1)", @"MULTIPOINT((1 0),(1 1),(1 1),(1 1))");
}

- (void) testIntersection_MultiPoint_LineString {
    IntersectionTest(GFMultiPoint, @"MULTIPOINT(0 0,0 0,1 0)", GFLineString, @"LINESTRING(1 0,2 0)", @"POINT(1 0)");
}

- (void) testIntersection_MultiPoint_MultiLineString {
    IntersectionTest(GFMultiPoint, @"MULTIPOINT(0 0,1 0,2 0)", GFMultiLineString, @"MULTILINESTRING((1 0,1 1,1 1,4 4))", @"POINT(1 0)");
}

- (void) testIntersection_LineString_LineString {
    IntersectionTest(GFLineString, @"LINESTRING(0 0,6 0)", GFLineString, @"LINESTRING(0 0,4 0)", @"LINESTRING(0 0,4 0)");
}

- (void) testIntersection_LineString_MultiLineString {
    IntersectionTest(GFLineString, @"LINESTRING(0 0,10 0,20 1)", GFMultiLineString, @"MULTILINESTRING((1 1,2 0,4 0),(1 1,3 0,4 0))", @"LINESTRING(2 0,4 0)");
}

- (void) testIntersection_LineString_Polygon {
    IntersectionTest(GFLineString, @"LINESTRING(240 190, 120 120)", GFPolygon, @"POLYGON((110 240, 50 80, 240 70, 110 240))", @"LINESTRING(240 190,176.542 152.983)");
}

- (void) testIntersection_MutliLineString_LineString {
    IntersectionTest(GFMultiLineString, @"MULTILINESTRING((0 0,10 0,20 1),(1 0,7 0))", GFLineString, @"LINESTRING(1 1,2 0,4 0)", @"LINESTRING(2 0,4 0)");
}

- (void) testIntersection_MutliLineString_MultiLineString {
    IntersectionTest(GFMultiLineString, @"MULTILINESTRING((0 0,101 0))", GFMultiLineString, @"MULTILINESTRING((-1 -1,1 0,101 0,200 -1))", @"LINESTRING(1 0,101 0)");
}

- (void) testIntersection_Polygon_Polygon {
    IntersectionTest(GFPolygon, @"POLYGON((20 20, 20 160, 160 160, 160 20, 20 20),(140 140, 40 140, 40 40, 140 40, 140 140))",
                     GFPolygon, @"POLYGON((80 100, 220 100, 220 240, 80 240, 80 100))",
                     @"POLYGON((80 160,80 140,40 140,40 40,140 40,140 100,160 100,160 20,20 20,20 160,80 160))");
}

- (void) testIntersection_Polygon_LineString {
    IntersectionTest(GFPolygon, @"POLYGON((5 5,15 15,15 5,5 5))", GFLineString, @"LINESTRING(0 0,10 10)", @"LINESTRING(5 5,10 10)");
}

- (void) testIntersection_Polygon_MultiPolygon {
    IntersectionTest(GFPolygon, @"POLYGON((20 20, 20 160, 160 160, 160 20, 20 20),(140 140, 40 140, 40 40, 140 40, 140 140))",
                     GFMultiPolygon, @"MULTIPOLYGON(((80 100, 220 100, 220 240, 80 240, 80 100)))",
                     @"POLYGON((80 160,80 140,40 140,40 40,140 40,140 100,160 100,160 20,20 20,20 160,80 160))");
}

- (void) testIntersection_MultiPolygon_Polygon {
    IntersectionTest(GFMultiPolygon, @"MULTIPOLYGON(((20 20, 20 160, 160 160, 160 20, 20 20),(140 140, 40 140, 40 40, 140 40, 140 140)))",
                    GFPolygon, @"POLYGON((80 100, 220 100, 220 240, 80 240, 80 100))",
                    @"POLYGON((160 100,160 20,20 20,20 160,80 160,80 140,40 140,40 40,140 40,140 100,160 100))");
}

- (void) testIntersection_MultiPolygon_MultiPolygon {
    IntersectionTest(GFMultiPolygon, @"MULTIPOLYGON(((0 1,2 5,5 3,0 1)),((1 1,5 2,5 0,1 1)))",
                    GFMultiPolygon, @"MULTIPOLYGON(((3 0,0 3,4 5,3 0)))",
                    @"MULTIPOLYGON(((0.666667 2.33333,1.33333 3.66667,2.85714 4.42857,3.76471 3.82353,3.47826 2.3913,1.42857 1.57143,0.666667 2.33333)),((1.8 1.2,3.31579 1.57895,3.09524 0.47619,2.33333 0.666667,1.8 1.2)))");
}

- (void) testIntersection_UnsupportedOperation {
    XCTAssertThrowsSpecificNamed([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] intersection: [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"]], NSException, NSInvalidArgumentException);
}

@end
