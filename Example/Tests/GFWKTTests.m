//
//  GeoFeaturesTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 04/14/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFWKTTests : XCTestCase
@end

#define WKTTest(wkt) XCTAssertEqualObjects([[GFGeometry geometryWithWKT: (wkt)] toWKTString], [(wkt) uppercaseString])
#define WKTTest2(wkt,expectedWKT) XCTAssertEqualObjects([[GFGeometry geometryWithWKT: (wkt)] toWKTString], [(expectedWKT) uppercaseString])

@implementation GFWKTTests

    - (void) testPoint {
        WKTTest (@"POINT(1 1)");
        WKTTest2(@"POINT()", @"POINT(0 0)");
        WKTTest2(@"POINT EMPTY", @"POINT(0 0)");
    }

    - (void) testMultiPoint {
        WKTTest (@"MULTIPOINT((1 1),(2 2))");
        WKTTest (@"MULTIPOINT()");
        WKTTest2(@"MULTIPOINT EMPTY", @"MULTIPOINT()");
    }

    - (void) testLineString {
        WKTTest (@"LINESTRING(40 60,120 110)");
        WKTTest (@"LINESTRING()");
        WKTTest2(@"LINESTRING EMPTY", @"LINESTRING()");
    }

    - (void) testMultiLineString {
        WKTTest (@"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))");
        WKTTest (@"MULTILINESTRING()");
        WKTTest2(@"MULTILINESTRING EMPTY", @"MULTILINESTRING()");
    }

    - (void) testPolygon {
        WKTTest (@"POLYGON((0 0,0 90,90 90,90 0,0 0))");
        WKTTest2(@"POLYGON()", @"POLYGON(())");
        WKTTest2(@"POLYGON EMPTY", @"POLYGON(())");
    }

    - (void) testMultiPolygon {
        WKTTest (@"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))");
        WKTTest (@"MULTIPOLYGON()");
        WKTTest2(@"MULTIPOLYGON EMPTY", @"MULTIPOLYGON()");
    }

    - (void) testGeometryCollection {
        WKTTest(@"GEOMETRYCOLLECTION(POLYGON((0 0,0 90,90 90,90 0,0 0)),POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140),LINESTRING(160 50,160 140),POINT(60 50),POINT(60 140),POINT(40 140))");
        WKTTest(@"GEOMETRYCOLLECTION()");
        WKTTest2(@"GEOMETRYCOLLECTION EMPTY", @"GEOMETRYCOLLECTION()");
    }

@end