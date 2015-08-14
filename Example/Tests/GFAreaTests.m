//
//  GeoFeaturesTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 04/14/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import "GFGeometryTests.h"
#import <MapKit/MapKit.h>
#import <XCTest/XCTest.h>

@interface GFAreaTests : XCTestCase
@end

#define AreaTest(input,expected) XCTAssertEqual([[GFGeometry geometryWithWKT: (input)] area], (expected))

@implementation GFAreaTests


    - (void) testPoint {
        AreaTest(@"POINT(0 0)", 0.0);
        AreaTest(@"POINT(1 1)", 0.0);
        AreaTest(@"POINT EMPTY", 0.0);
    }

    - (void) testMultiPoint {
        AreaTest(@"MULTIPOINT(0 0,1 1)", 0.0);
        AreaTest(@"MULTIPOINT EMPTY", 0.0);
    }

    - (void) testLineString {
        AreaTest(@"LINESTRING(0 0,1 1)", 0.0);
        AreaTest(@"LINESTRING EMPTY", 0.0);
    }

    - (void) testMultiLineString {
        AreaTest(@"MULTILINESTRING((0 0,1 1),(-1 0,1 0))", 0.0);
        AreaTest(@"MULTILINESTRING EMPTY", 0.0);
    }

    - (void) testPolygon {
        AreaTest(@"POLYGON((0 0,0 7,4 2,2 0,0 0))", 16);
        AreaTest(@"POLYGON EMPTY", 0.0);
    }


@end