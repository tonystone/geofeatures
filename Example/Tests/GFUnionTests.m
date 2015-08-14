//
//  GeoFeaturesTests.m
//  GeoFeaturesTests
//
//  Created by Tony Stone on 04/14/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import <GeoFeatures/GeoFeatures.h>
#import <XCTest/XCTest.h>

@interface GFUnionTests : XCTestCase
@end

@implementation GFUnionTests

    - (NSString *)runTestWithInput1WKT: (NSString *) input1WKT input2WKT: (NSString *) input2WKT  {
        GFGeometry * testGeometry1 = [GFGeometry geometryWithWKT: input1WKT];
        GFGeometry * testGeometry2 = [GFGeometry geometryWithWKT: input2WKT];

        GFGeometry * result = [testGeometry1 union_: testGeometry2];

        return [result toWKTString];
    }

    - (void) testPoint {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POINT(1 1)"
                                               input2WKT: @"POINT(2 2)"],
                              
                              @"MULTIPOINT((1 1),(2 2))");
        
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POINT(40 60)"
                                               input2WKT: @"MULTIPOINT((40 60),(40 60))"],
                              
                              @"MULTIPOINT((40 60))");
    }

    - (void) testPolygon {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POLYGON((0 0,0 90,90 90,90 0,0 0))"
                                               input2WKT: @"POLYGON((120 0,120 90,210 90,210 0,120 0))"],
                              
                              @"MULTIPOLYGON(((0 0,0 90,90 90,90 0,0 0)),((120 0,120 90,210 90,210 0,120 0)))");
        
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"POLYGON((120 0,120 90,210 90,210 0,120 0))"
                                               input2WKT: @"POLYGON((120 0,120 90,210 90,210 0,120 0))"],
                              
                              @"POLYGON((120 90,210 90,210 0,120 0,120 90))");
    }

    - (void) testMultiPolygon {
        XCTAssertEqualObjects([self runTestWithInput1WKT: @"MULTIPOLYGON(((0 0,0 90,90 90,90 0,0 0)))"
                                               input2WKT: @"MULTIPOLYGON(((120 0,120 90,210 90,210 0,120 0)))"],
                          
                          @"MULTIPOLYGON(((0 0,0 90,90 90,90 0,0 0)),((120 0,120 90,210 90,210 0,120 0)))");
    }


@end