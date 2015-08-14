//
// Created by Tony Stone on 4/16/15.
// Copyright (c) 2015 Tony Stone. All rights reserved.
//

#import "GFGeometryTests.h"
#import <XCTest/XCTest.h>


static NSString * invalidGeometryJSONString = @"{ \"type\": \"%@\","
    "    \"coordinates\": {}"
    "   }";

@implementation GFGeometryTests

    - (void)testConstruction {

        XCTAssertNotNil(geometry1a);
        XCTAssertNotNil(geometry2);

        XCTAssertEqual([geometry1a class], expectedClass);
        XCTAssertEqual([geometry2 class], expectedClass);
    }

    - (void)testFailedConstruction {
    
        NSDictionary * testJSON  = [NSJSONSerialization JSONObjectWithData: [[NSString stringWithFormat:invalidGeometryJSONString, geoJSONGeometryName] dataUsingEncoding: NSUTF8StringEncoding]  options: 0 error: nil];
        
        XCTAssertThrowsSpecificNamed([GFGeometry geometryWithGeoJSONGeometry: testJSON], NSException, @"Invalid GeoJSON");
    }

    - (void) testDescription {
    
        // Currently we only check if it returns something and its not nill
        
        XCTAssertNotNil([geometry1a description]);
        XCTAssertNotNil([geometry2 description]);
        
        XCTAssertTrue ([[geometry1a description] length] > 0);
        XCTAssertTrue ([[geometry2 description] length] > 0);
    }

@end
