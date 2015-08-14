//
//  GeoFeaturesTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 04/14/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFWithinTests : XCTestCase
@end

#define WithinTest(input1,input2,expected) XCTAssertEqual([[GFGeometry geometryWithWKT: (input1)] within: [GFGeometry geometryWithWKT: (input2)]], (expected))

@implementation GFWithinTests

    - (void) testPoint {
        WithinTest(@"POINT(4 1)", @"POINT(4 1)", true);
        WithinTest(@"POINT(0 0)", @"POINT(4 1)", false);
    }


    - (void) testLineString {
        WithinTest(@"POINT(0.5 0.5)", @"LINESTRING(0 0,1 1)", true);
        WithinTest(@"POINT(2 2)", @"LINESTRING(0 0,1 1)", false);
    }

    - (void) testPolygon {
        WithinTest(@"POINT(4 1)", @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                   "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", true);
        
        WithinTest(@"LINESTRING(4 1,4 2)", @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                   "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", true);
        
        WithinTest(@"LINESTRING(0 0,1 1)", @"POLYGON((2 1.3,2.4 1.7,2.8 1.8,3.4 1.2,3.7 1.6,3.4 2,4.1 3,5.3 2.6,5.4 1.2,4.9 0.8,2.9 0.7,2 1.3)"
                   "(4.0 2.0, 4.2 1.4, 4.8 1.9, 4.4 2.2, 4.0 2.0))", false);
        
    }


@end