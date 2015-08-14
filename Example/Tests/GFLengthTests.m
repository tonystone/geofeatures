//
//  GeoFeaturesTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 04/14/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFLengthTests : XCTestCase
@end

#define LengthTest(input,expected) XCTAssertEqual([[GFGeometry geometryWithWKT: (input)] length], (expected))

@implementation GFLengthTests


    - (void) testPoint {
        LengthTest(@"POINT(0 0)", 0.0);
        LengthTest(@"POINT(1 1)", 0.0);
        LengthTest(@"POINT EMPTY", 0.0);
    }

    - (void) testMultiPoint {
        LengthTest(@"MULTIPOINT(0 0,1 1)", 0.0);
        LengthTest(@"MULTIPOINT EMPTY", 0.0);
    }


    - (void) testLineString {
        LengthTest(@"LINESTRING(0 0,1 1)", 1.4142135623730951);
        LengthTest(@"LINESTRING EMPTY", 0.0);
    }

    - (void) testMultiLineString {
        LengthTest(@"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 3.4142135623730949);
        LengthTest(@"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testPolygon {
        LengthTest(@"POLYGON((0 0,1 1,1 0))", 0.0);
        LengthTest(@"POLYGON EMPTY", 0.0);
    }

    - (void) testMultiPolygon {
        LengthTest(@"MULTIPOLYGON(((0 0,1 1,1 0)),((0 0,1 1,1 0)))", 0.0);
        LengthTest(@"MULTIPOLYGON(((0 0,1 1,1 0)),((0 0,1 1,1 0)))", 0.0);
        LengthTest(@"MULTIPOLYGON EMPTY", 0.0);
    }


@end