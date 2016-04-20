//
//  GFDifferenceTests.m
//  GeoFeatures
//
//  Created by Tony Stone on 4/14/16.
//  Copyright © 2016 Tony Stone. All rights reserved.
//

@import XCTest;
@import GeoFeatures;

@interface GFDifferenceTests : XCTestCase

@end

#define DiffereneceTest(T1,input1,T2, input2,expected) XCTAssertEqualObjects([[[[T1 alloc] initWithWKT: (input1)] difference: [[T2 alloc] initWithWKT: (input2)]] toWKTString], (expected))

@implementation GFDifferenceTests


- (void) testDifference_Point_LineString {
    DiffereneceTest(GFPoint, @"POINT(3 3)", GFLineString, @"LINESTRING(0 0,2 2)", @"POINT(3 3)");
}

- (void) testDifference_Point_MultiPoint {
    DiffereneceTest(GFPoint, @"POINT(3 3)", GFMultiPoint, @"MULTIPOINT((0 0),(2 0))", @"POINT(3 3)");
}

- (void) testDifference_MutliPoint_Point {
    DiffereneceTest(GFMultiPoint, @"MULTIPOINT((0 0),(2 0))", GFPoint, @"POINT(3 3)", @"MULTIPOINT((0 0),(2 0))");
}

- (void) testDifference_MultiPoint_LineString {
    DiffereneceTest(GFMultiPoint, @"MULTIPOINT(40 90,20 20,70 70)", GFLineString, @"LINESTRING(20 20,110 110,170 50,130 10,70 70)", @"POINT(40 90)");
}

- (void) testDifference_MultiPoint_MultiLineString {
    DiffereneceTest(GFMultiPoint, @"MULTIPOINT(0 0,1 0,2 0)", GFMultiLineString, @"MULTILINESTRING((1 0,1 1,1 1,4 4))", @"MULTIPOINT((0 0),(2 0))");
}

- (void) testDifference_LineString_LineString {
    DiffereneceTest(GFLineString, @"LINESTRING(0 0,1 1,2 1,3 2)", GFLineString, @"LINESTRING(0 2,1 1,2 1,3 0)", @"MULTILINESTRING((0 0,1 1),(2 1,3 2))");
}

- (void) testDifference_LineString_MultiLineString {
    DiffereneceTest(GFLineString, @"LINESTRING(0 0,10 0,20 1)", GFMultiLineString, @"MULTILINESTRING((1 1,2 2,4 3),(1 1,2 2,5 3))", @"LINESTRING(0 0,10 0,20 1)");
}

- (void) testDifference_LineString_Polygon {
    DiffereneceTest(GFLineString, @"LINESTRING(0 1,1 2,3 2,4 3,6 3,7 4)", GFPolygon, @"POLYGON((2 0,2 5,5 5,5 0,2 0))", @"MULTILINESTRING((0 1,1 2,2 2),(5 3,6 3,7 4))");
}

- (void) testDifference_MutliLineString_LineString {
    DiffereneceTest(GFMultiLineString, @"MULTILINESTRING((0 0,10 0,20 1),(1 0,7 0))", GFLineString, @"LINESTRING(1 1,2 2,4 3)", @"MULTILINESTRING((0 0,10 0,20 1),(1 0,7 0))");
}

- (void) testDifference_MutliLineString_MultiLineString {
    DiffereneceTest(GFMultiLineString, @"MULTILINESTRING((0 0,10 0,20 1),(1 0,7 0))", GFMultiLineString, @"MULTILINESTRING((1 1,2 2,4 3),(1 1,2 2,5 3))", @"MULTILINESTRING((0 0,10 0,20 1),(1 0,7 0))");
}

- (void) testDifference_Polygon_Polygon {
    DiffereneceTest(GFPolygon, @"POLYGON((10 10, 100 10, 10 11, 10 10))",
                    GFPolygon, @"POLYGON((90 0, 200 0, 200 200, 90 200, 90 0))",
                    @"POLYGON((90 10,100 10,90 10.1111,90 200,200 200,200 0,90 0,90 10))");
}

- (void) testDifference_Polygon_MultiPolygon {
    DiffereneceTest(GFPolygon, @"POLYGON((0 0, 210 0, 210 230, 0 230, 0 0))",
                    GFMultiPolygon, @"MULTIPOLYGON(((40 20, 0 0, 20 40, 60 60, 40 20)),((60 90, 60 60, 90 60, 90 90, 60 90)),((70 120, 90 90, 100 120, 70 120)),((120 70, 90 90, 120 100, 120 70)))",
                    @"MULTIPOLYGON(((60 90,90 90,90 60,60 60,60 90)),((70 120,100 120,90 90,70 120)))");
}

- (void) testDifference_MultiPolygon_Polygon {
    DiffereneceTest(GFMultiPolygon, @"MULTIPOLYGON(((40 20, 0 0, 20 40, 60 60, 40 20)),((60 90, 60 60, 90 60, 90 90, 60 90)),((70 120, 90 90, 100 120, 70 120)),((120 70, 90 90, 120 100, 120 70)))",
                    GFPolygon, @"POLYGON((0 0, 210 0, 210 230, 0 230, 0 0))",
                    @"POLYGON((0 0,20 40,60 60,40 20,0 0))");
}

- (void) testDifference_MultiPolygon_MultiPolygon {
    DiffereneceTest(GFMultiPolygon, @"MULTIPOLYGON(((0 1,2 5,5 3,0 1)),((1 1,5 2,5 0,1 1)))",
                    GFMultiPolygon, @"MULTIPOLYGON(((3 0,0 3,4 5,3 0)))",
                    @"MULTIPOLYGON(((1.33333 3.66667,2 5,2.85714 4.42857,1.33333 3.66667)),((0.666667 2.33333,1.42857 1.57143,0 1,0.666667 2.33333)),((3.76471 3.82353,5 3,3.47826 2.3913,3.76471 3.82353)),((3.31579 1.57895,5 2,5 0,3.09524 0.47619,3.31579 1.57895)),((1.8 1.2,2.33333 0.666667,1 1,1.8 1.2)))");
}

- (void) testDifference_UnsupportedOperation {
    XCTAssertThrowsSpecificNamed([[[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"] difference: [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION()"]], NSException, NSInvalidArgumentException);
}

@end
