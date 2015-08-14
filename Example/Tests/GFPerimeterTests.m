//
//  GFPerimeterTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 06/15/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFPerimeterTests : XCTestCase
@end

#define PerimeterTest(input,expected) XCTAssertEqual([[GFGeometry geometryWithWKT: (input)] perimeter], (expected))

@implementation GFPerimeterTests

    - (void) testPoint {
        PerimeterTest(@"POINT(0 0)", 0.0);
        PerimeterTest(@"POINT(1 1)", 0.0);
        PerimeterTest(@"POINT EMPTY", 0.0);
    }

    - (void) testMultiPoint {
        PerimeterTest(@"MULTIPOINT(0 0,1 1)", 0.0);
        PerimeterTest(@"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testLineString {
        PerimeterTest(@"LINESTRING(0 0,1 1)", 0.0);
        PerimeterTest(@"LINESTRING EMPTY", 0.0);
    }

    - (void) testMultiLineString {
        PerimeterTest(@"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 0.0);
        PerimeterTest(@"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testPolygon {
        PerimeterTest(@"POLYGON((0 0,0 4,4 4,4 0,0 0),(1 1,2 1,2 2,1 2,1 1))", 20);
        PerimeterTest(@"POLYGON EMPTY", 0.0);
    }

    - (void) testMultiPolygon {
        PerimeterTest(@"MULTIPOLYGON(((0 0,0 1,1 0,0 0)))", 1.0 + 1.0 + sqrt(2.0));
        PerimeterTest(@"MULTIPOLYGON EMPTY", 0.0);
    }


@end