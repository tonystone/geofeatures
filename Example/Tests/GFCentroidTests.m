//
//  GeoFeaturesTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 04/14/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFCentroidTests : XCTestCase
@end

#define CentroidTest(input,expected) XCTAssertEqualObjects([[[GFGeometry geometryWithWKT: (input)] centroid] toWKTString], (expected))

@implementation GFCentroidTests


    - (void) testPoint {
        CentroidTest(@"POINT(1 1)", @"POINT(1 1)");
    }


    - (void) testMultiPoint {
        CentroidTest(@"MULTIPOINT (-1 0,-1 2,-1 3,-1 4,-1 7,0 1,0 3,1 1,2 0,6 0,7 8,9 8,10 6)", @"POINT(2.30769 3.30769)");
    }


    - (void) testPolygon {
        CentroidTest(@"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                     "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", @"POINT(4.04663 1.6349)");
    }


@end